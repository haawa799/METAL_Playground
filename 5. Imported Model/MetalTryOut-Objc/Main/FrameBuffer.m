//
//  FrameBufferHelper.m
//  Imported Model
//
//  Created by Andrew K. on 7/3/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "FrameBuffer.h"
#import "Imported_Model-Swift.h"

@implementation FrameBuffer
{
@private
    __weak CAMetalLayer *_metalLayer;
    
    id <MTLTexture>  _depthTex;
    id <MTLTexture>  _stencilTex;
    id <MTLTexture>  _msaaTex;
}

@synthesize currentDrawable      = _currentDrawable;
@synthesize renderPassDescriptor = _renderPassDescriptor;


#pragma mark - Public API

- (instancetype)initWithMetalView:(MetalView *)metalView
{
    self = [super init];
    // setting this to yes will allow Main thread to display framebuffer when
    // view:setNeedDisplay: is called by main thread
    _metalLayer = (CAMetalLayer *)metalView.layer;
    
    _metalLayer.presentsWithTransaction = NO;
    _metalLayer.drawsAsynchronously     = YES;
    
    _device = MTLCreateSystemDefaultDevice();
    
    _depthPixelFormat   = MTLPixelFormatDepth32Float;
    _stencilPixelFormat = MTLPixelFormatInvalid;
    _sampleCount        = 4;
    
    _metalLayer.device          = _device;
    _metalLayer.pixelFormat     = MTLPixelFormatBGRA8Unorm;
    _metalLayer.framebufferOnly = YES;
    
    _drawableSize = metalView.bounds.size;
    
    return self;
}

- (void) releaseTextures
{
    _depthTex   = nil;
    _stencilTex = nil;
    _msaaTex    = nil;
}

- (void)displayWithDrawableSize:(CGSize)drawableSize
{
    // Create autorelease pool per frame to avoid possible deadlock situations
    // because there are 3 CAMetalDrawables sitting in an autorelease pool.
    
    @autoreleasepool
    {
        if(_layerSizeDidUpdate)
        {
            
            _metalLayer.drawableSize = drawableSize;
            _layerSizeDidUpdate = NO;
        }
        
        // draw
        _currentDrawable    = nil;
    }
}

#pragma mark - Private API

- (void) setupRenderPassDescriptorForTexture:(id <MTLTexture>) texture
{
    // create lazily
    if (_renderPassDescriptor == nil)
        _renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    
    // create a color attachment every frame since we have to recreate the texture every frame
    MTLRenderPassColorAttachmentDescriptor *colorAttachment = [MTLRenderPassColorAttachmentDescriptor new];
    colorAttachment.texture = texture;
    
    // make sure to clear every frame for best performance
    colorAttachment.loadAction = MTLLoadActionClear;
    colorAttachment.clearColor = MTLClearColorMake(0.65, 0.65, 0.65, 1.0);
    
    // if sample count is greater than 1, render into using MSAA, then resolve into our color texture
    if(_sampleCount > 1)
    {
        BOOL doUpdate =     ( _msaaTex.width       != texture.width  )
        ||  ( _msaaTex.height      != texture.height )
        ||  ( _msaaTex.sampleCount != _sampleCount   );
        
        if(!_msaaTex || (_msaaTex && doUpdate))
        {
            MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: MTLPixelFormatBGRA8Unorm
                                                                                            width: texture.width
                                                                                           height: texture.height
                                                                                        mipmapped: NO];
            desc.textureType = MTLTextureType2DMultisample;
            
            // sample count was specified to the view by the renderer.
            // this must match the sample count given to any pipeline state using this render pass descriptor
            desc.sampleCount = _sampleCount;
            
            _msaaTex = [_device newTextureWithDescriptor: desc];
        }
        
        // When multisampling, perform rendering to _msaaTex, then resolve
        // to 'texture' at the end of the scene
        [colorAttachment setTexture: _msaaTex];
        [colorAttachment setResolveTexture: texture];
        
        // set store action to resolve in this case
        [colorAttachment setStoreAction: MTLStoreActionMultisampleResolve];
    }
    else
    {
        // store only attachments that will be presented to the screen, as in this case
        [colorAttachment setStoreAction: MTLStoreActionStore];
    } // color0
    
    // set the newly created attachment on the descriptor as color attachment at index 0
    [_renderPassDescriptor.colorAttachments setObject:colorAttachment atIndexedSubscript:0];
    
    
    // Now create the depth and stencil attachments
    
    if(_depthPixelFormat != MTLPixelFormatInvalid)
    {
        BOOL doUpdate =     ( _depthTex.width       != texture.width  )
        ||  ( _depthTex.height      != texture.height )
        ||  ( _depthTex.sampleCount != _sampleCount   );
        
        if(!_depthTex || doUpdate)
        {
            //  If we need a depth texture and don't have one, or if the depth texture we have is the wrong size
            //  Then allocate one of the proper size
            MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: _depthPixelFormat
                                                                                            width: texture.width
                                                                                           height: texture.height
                                                                                        mipmapped: NO];
            
            desc.textureType = (_sampleCount > 1) ? MTLTextureType2DMultisample : MTLTextureType2D;
            desc.sampleCount = _sampleCount;
            
            _depthTex = [_device newTextureWithDescriptor: desc];
            
            MTLRenderPassDepthAttachmentDescriptor *depthAttachment = [MTLRenderPassDepthAttachmentDescriptor new];
            depthAttachment.texture = _depthTex;
            [depthAttachment setLoadAction:MTLLoadActionClear];
            depthAttachment.clearDepth = 1.0;
            [depthAttachment setStoreAction: MTLStoreActionDontCare];
            
            _renderPassDescriptor.depthAttachment = depthAttachment;
        }
    } // depth
    
    if(_stencilPixelFormat != MTLPixelFormatInvalid)
    {
        BOOL doUpdate  =    ( _stencilTex.width       != texture.width  )
        ||  ( _stencilTex.height      != texture.height )
        ||  ( _stencilTex.sampleCount != _sampleCount   );
        
        if(!_stencilTex || doUpdate)
        {
            //  If we need a stencil texture and don't have one, or if the depth texture we have is the wrong size
            //  Then allocate one of the proper size
            
            MTLTextureDescriptor* desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat: _stencilPixelFormat
                                                                                            width: texture.width
                                                                                           height: texture.height
                                                                                        mipmapped: NO];
            
            desc.textureType = (_sampleCount > 1) ? MTLTextureType2DMultisample : MTLTextureType2D;
            desc.sampleCount = _sampleCount;
            
            _stencilTex = [_device newTextureWithDescriptor: desc];
            
            MTLRenderPassStencilAttachmentDescriptor* stencilAttachment = [MTLRenderPassStencilAttachmentDescriptor new];
            stencilAttachment.texture = _stencilTex;
            [stencilAttachment setLoadAction:MTLLoadActionClear];
            stencilAttachment.clearStencil = 0;
            [stencilAttachment setStoreAction: MTLStoreActionDontCare];
            
            _renderPassDescriptor.stencilAttachment = stencilAttachment;
            
        }
    } //stencil
}

- (MTLRenderPassDescriptor *) renderPassDescriptor
{
    id <CAMetalDrawable> drawable = self.currentDrawable;
    if(!drawable)
    {
        NSLog(@">> ERROR: Failed to get a drawable!");
        _renderPassDescriptor = nil;
    }
    else
    {
        [self setupRenderPassDescriptorForTexture: drawable.texture];
    }
    
    return _renderPassDescriptor;
}


- (id <CAMetalDrawable>) currentDrawable
{
    while (_currentDrawable == nil)
    {
        _currentDrawable = [_metalLayer newDrawable];
        
        if(!_currentDrawable)
        {
            NSLog(@"CurrentDrawable is nil");
        }
    }
    
    return _currentDrawable;
}

@end
