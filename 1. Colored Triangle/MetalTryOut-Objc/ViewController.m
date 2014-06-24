//
//  ViewController.m
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/20/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "ViewController.h"
#import "MetalView.h"
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import "Triangle-Swift.h"

static const int kNumberOfVertices = 3;
static const int kNumberOfPositionComponents = 4;
static const int kNumberOfColorComponents = 4;


static const float verticesData[(kNumberOfPositionComponents + kNumberOfColorComponents)*kNumberOfVertices] =
{
//    x       y     z     w          r       g      b     a
    -1.0f,  -1.0f, 0.0f, 1.0f,      1.0f,   0.0f,  0.0f, 1.0f,  //A
     1.0f,  -1.0f, 0.0f, 1.0f,      0.0f,   1.0f,  0.0f, 1.0f,  //B
     0.0f,   0.0f, 0.0f, 1.0f,      0.0f,   0.0f,  1.0f, 1.0f   //C
};

@implementation ViewController
{
    MetalView *_metalView;
    
    id <MTLDevice> _device;
    id <MTLCommandQueue> _commandQ;
    id <MTLBuffer> _vertexBuffer;
    id <MTLRenderPipelineState> _renderPipeline;
    
    BaseEffect *_baseEffect;
}
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self.view isKindOfClass:[MetalView class]]){
        _metalView = (MetalView *)self.view;
    }
    _metalView.metalViewDelegate = self;
    [self setupMetal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_metalView resume];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_metalView pause];
}

- (void)dealloc
{
    [self tearDownMetal];
}

#pragma mark MetalViewProtocol

-(void)update:(CFTimeInterval)delta
{
    [self draw];
}


//================================================
#pragma mark - METAL related
//================================================

- (void)setupMetal
{
    // Setup Device commandQueue and vertexBuffer
    _device = MTLCreateSystemDefaultDevice();
    _commandQ = [_device newCommandQueue];
    _vertexBuffer = [_device newBufferWithBytes:verticesData length:sizeof(verticesData) options:0];
    
//    // Setup MTLRenderPipline descriptor object with vertex and fragment shader
//    MTLRenderPipelineDescriptor *pipeLineDescriptor = [MTLRenderPipelineDescriptor new];
//    id <MTLLibrary> library = [_device newDefaultLibrary];
//    pipeLineDescriptor.vertexFunction = [library newFunctionWithName:@"myVertexShader"];
//    pipeLineDescriptor.fragmentFunction = [library newFunctionWithName:@"myFragmentShader"];
//    pipeLineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
//    
//    // Compile the MTLRenderPipline object into immutable and cheap for use MTLRenderPipelineState
//    NSError *error;
//    _renderPipeline = [_device newRenderPipelineStateWithDescriptor:pipeLineDescriptor error:&error];
//    if(error != nil){
//        NSLog(@"%@",[error localizedDescription]);
//    }
//    
//    //
    
    _baseEffect = [[BaseEffect alloc] initWithDevice:_device
                                    vertexShaderName:@"myVertexShader"
                                  fragmentShaderName:@"myFragmentShader"];
    
    _renderPipeline = [_baseEffect compile];
}

- (void)tearDownMetal
{
    _device = nil;
    _commandQ = nil;
    _vertexBuffer = nil;
    _renderPipeline = nil;
}

- (void)draw
{
    // Get command buffer from commandQueue
    id <MTLCommandBuffer> commandBuffer = [_commandQ commandBuffer];
    
    // Ask METAL layer for a renderBuffer in which we will draw
    // NOTE: This might block your application if layer has no drawable to provide
    id <CAMetalDrawable> drawable = [(CAMetalLayer *)self.view.layer newDrawable];
    
    
    // MTLRenderPassDescriptor object represents a collection of configurable states
    MTLRenderPassDescriptor *renderPassDesc = [MTLRenderPassDescriptor new];
    renderPassDesc.colorAttachments[0].texture = drawable.texture;
    renderPassDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
    renderPassDesc.colorAttachments[0].clearValue = MTLClearValueMakeColor(0, 104.f/255, 55.f/255, 1);
    
    
    // Create MTLRenderCommandEncoder object which translates all states into a command for GPU
    id <MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDesc];
    [commandEncoder setRenderPipelineState:_renderPipeline];
    [commandEncoder setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
    [commandEncoder endEncoding];
    
    
    // After command in command buffer is encoded for GPU we provide drawable that will be invoked when this command buffer has been scheduled for execution
    [commandBuffer presentDrawable:drawable];
    
    // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
    [commandBuffer commit];
}


@end
