//
//  MetalView.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import QuartzCore
import Metal

protocol MetalViewProtocol
{
    func render(metalView : MetalView)
    func reshape(metalView : MetalView)
}

class MetalView: UIView
{
    //Public API
    var metalViewDelegate: MetalViewProtocol?
    var device: MTLDevice!
    var drawableSize: CGSize!
    
    var depthPixelFormat: MTLPixelFormat!
    var stencilPixelFormat: MTLPixelFormat!
    var sampleCount: Int!
    
    
    func setFPSLabelHidden(hidden: Bool){
        if let label = fpsLabel{
            label.hidden = hidden
        }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        setup()
    }
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
        setup()
    }
    
    func display()
    {
        if(_layerSizeDidUpdate)
        {
            drawableSize = self.bounds.size;
            drawableSize = CGSize(width: drawableSize.width * CGFloat(self.contentScaleFactor), height: drawableSize.height * CGFloat(self.contentScaleFactor))
            
            _metalLayer.drawableSize = drawableSize
            
            metalViewDelegate?.reshape(self)
            
            _layerSizeDidUpdate = false
        }
        
        // draw
        self.metalViewDelegate?.render(self)
        _currentDrawable = nil;
    }
    
    func releaseTextures()
    {
        _depthTex = nil
        _stencilTex = nil
        _msaaTex = nil
    }
    
    func renderPassDescriptor() -> MTLRenderPassDescriptor?
    {
        if let drawable = currentDrawable()
        {
            setupRenderPassDescriptorForTexture(drawable.texture)
        }
        else
        {
            println(">> ERROR: Failed to get a drawable!")
            _renderPassDescriptor = nil;
        }
        
//        setupRenderPassDescriptorForTexture(currentDrawable()!.texture)
        return _renderPassDescriptor
    }
    
    func currentDrawable() -> CAMetalDrawable?
    {
        while (_currentDrawable == nil)
        {
            _currentDrawable = _metalLayer.newDrawable();
            
            if(!_currentDrawable)
            {
                println("CurrentDrawable is nil")
            }
        }
        
        return _currentDrawable;
    }
    
    //Private
    var lastFrameTimestamp: CFTimeInterval?
    var fpsLabel: UILabel?
    
    var _renderPassDescriptor: MTLRenderPassDescriptor!
    var _currentDrawable: CAMetalDrawable!
    
    weak var _metalLayer: CAMetalLayer!
    var _layerSizeDidUpdate: Bool!
    var _depthTex: MTLTexture!
    var _stencilTex: MTLTexture!
    var _msaaTex: MTLTexture!
    
    override class func layerClass() -> AnyClass{
        return CAMetalLayer.self
    }
    override func layoutSubviews(){
        var rightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)
        var botConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        var heightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
        var widthConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        
        self.addConstraints([rightConstraint,botConstraint,widthConstraint,heightConstraint])
        
        _layerSizeDidUpdate = true
        
        super.layoutSubviews()
    }
    func setup(){
        fpsLabel = UILabel(frame: CGRectZero)
        fpsLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        fpsLabel!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        self.addSubview(fpsLabel)
    
        
        self.opaque          = true
        self.backgroundColor = nil
        
        // setting this to yes will allow Main thread to display framebuffer when
        // view:setNeedDisplay: is called by main thread
        _metalLayer = self.layer as CAMetalLayer
        
        self.contentScaleFactor = UIScreen.mainScreen().scale
        
        _metalLayer.presentsWithTransaction = false
        _metalLayer.drawsAsynchronously     = true
        
        device = MTLCreateSystemDefaultDevice()
        
        _metalLayer.device          = device
        _metalLayer.pixelFormat     = MTLPixelFormat.FormatBGRA8Unorm
        _metalLayer.framebufferOnly = true
        
        drawableSize = self.bounds.size
        
    }
    func setupRenderPassDescriptorForTexture(texture: MTLTexture){
        // create lazily
        if _renderPassDescriptor == nil
        {
            _renderPassDescriptor = MTLRenderPassDescriptor()
        }
        
        // create a color attachment every frame since we have to recreate the texture every frame
        var colorAttachment = MTLRenderPassAttachmentDescriptor()
        colorAttachment.texture = texture
        
        // make sure to clear every frame for best performance
        colorAttachment.loadAction = MTLLoadAction.Clear
//        colorAttachment.clearValue = MTLClearColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0)
        
        // if sample count is greater than 1, render into using MSAA, then resolve into our color texture
        if sampleCount > 1
        {
            var doUpdate =     ( _msaaTex.width       != texture.width  )
                ||  ( _msaaTex.height      != texture.height )
                ||  ( _msaaTex.sampleCount != sampleCount   )
            
            if ((_msaaTex == nil) || ((_msaaTex != nil) && doUpdate))
            {
                var desc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.FormatBGRA8Unorm, width: texture.width, height: texture.height, mipmapped: false)
                desc.textureType = MTLTextureType.Type2DMultisample
                
                // sample count was specified to the view by the renderer.
                // this must match the sample count given to any pipeline state using this render pass descriptor
                desc.sampleCount = sampleCount
                
                _msaaTex = device.newTextureWithDescriptor(desc)
            }

            // When multisampling, perform rendering to _msaaTex, then resolve
            // to 'texture' at the end of the scene
            colorAttachment.texture = _msaaTex
            colorAttachment.resolveTexture = texture
            
            // set store action to resolve in this case
            colorAttachment.storeAction = MTLStoreAction.MultisampleResolve
        }
        else
        {
            // store only attachments that will be presented to the screen, as in this case
            colorAttachment.storeAction = MTLStoreAction.Store
        } // color0
        
        // set the newly created attachment on the descriptor as color attachment at index 0
        _renderPassDescriptor.colorAttachments.setObject(colorAttachment, atIndexedSubscript: 0)
        
        
        // Now create the depth and stencil attachments
        
        if(depthPixelFormat != MTLPixelFormat.FormatInvalid)
        {
            var doUpdate =     ( _depthTex.width       != texture.width  )
                ||  ( _depthTex.height      != texture.height )
                ||  ( _depthTex.sampleCount != sampleCount   )
            
            if((_depthTex != nil) || doUpdate)
            {
                //  If we need a depth texture and don't have one, or if the depth texture we have is the wrong size
                //  Then allocate one of the proper size
                var desc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(depthPixelFormat, width: texture.width, height: texture.height, mipmapped: false)
                if sampleCount > 1
                {
                    desc.textureType = MTLTextureType.Type2DMultisample
                }
                else
                {
                    desc.textureType = MTLTextureType.Type2D
                }
                
                desc.sampleCount = sampleCount
                
                _depthTex = device.newTextureWithDescriptor(desc)
                
                var depthAttachment = MTLRenderPassAttachmentDescriptor()
                depthAttachment.texture = _depthTex
                depthAttachment.loadAction = MTLLoadAction.Clear
//                depthAttachment.clearValue = MTLClearValueMakeDepth(1.0)
                depthAttachment.storeAction = MTLStoreAction.DontCare
                
                _renderPassDescriptor.depthAttachment = depthAttachment
            }
        } // depth
        
        if(stencilPixelFormat != MTLPixelFormat.FormatInvalid)
        {
            var doUpdate  =    ( _stencilTex.width       != texture.width  )
                ||  ( _stencilTex.height      != texture.height )
                ||  ( _stencilTex.sampleCount != sampleCount   );
            
            if((_stencilTex != nil) || doUpdate)
            {
                //  If we need a stencil texture and don't have one, or if the depth texture we have is the wrong size
                //  Then allocate one of the proper size
                
                var desc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(stencilPixelFormat, width: texture.width, height: texture.height, mipmapped: false)
                
                if sampleCount > 1
                {
                    desc.textureType =  MTLTextureType.Type2DMultisample
                }
                else
                {
                    desc.textureType = MTLTextureType.Type2D
                }
                
                desc.sampleCount = sampleCount
                
                _stencilTex = device.newTextureWithDescriptor(desc)
                
                var stencilAttachment = MTLRenderPassAttachmentDescriptor()
                stencilAttachment.texture = _stencilTex
                stencilAttachment.loadAction = MTLLoadAction.Clear
//                stencilAttachment.clearValue = MTLClearValueMakeStencil(0)
                stencilAttachment.storeAction = MTLStoreAction.DontCare
                _renderPassDescriptor.stencilAttachment = stencilAttachment
                
            }
        } //stencil
    }
    
}
