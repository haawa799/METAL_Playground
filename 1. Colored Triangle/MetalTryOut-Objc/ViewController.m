//
//  ViewController.m
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/20/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "ViewController.h"
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import "Triangle-Swift.h"

@interface ViewController () <MetalViewProtocol>

@end

@implementation ViewController
{
    MetalView *_metalView;
    
    id <MTLDevice> _device;
    id <MTLCommandQueue> _commandQ;
    id <MTLRenderPipelineState> _renderPipeline;
    
    Triangle *_triangle;
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
    
    
    _baseEffect = [[BaseEffect alloc] initWithDevice:_device
                                    vertexShaderName:@"myVertexShader"
                                  fragmentShaderName:@"myFragmentShader"];
    
    _triangle = [[Triangle alloc] initWithBaseEffect:_baseEffect];
    
    _renderPipeline = [_baseEffect compile];
}

- (void)tearDownMetal
{
    _device = nil;
    _commandQ = nil;
    _triangle = nil;
    _renderPipeline = nil;
}

- (void)draw
{
    // Ask METAL layer for a renderBuffer in which we will draw
    // NOTE: This might block your application if layer has no drawable to provide
    id <CAMetalDrawable> drawable = [(CAMetalLayer *)self.view.layer newDrawable];
    
    [_triangle render:_commandQ drawable:drawable];
}


@end
