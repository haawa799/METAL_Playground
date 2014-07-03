//
//  FrameBufferHelper.h
//  Imported Model
//
//  Created by Andrew K. on 7/3/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>

@class MetalView;

@interface FrameBuffer : NSObject

+ (MTLRenderPassAttachmentDescriptor *)colorAttachment:(id <MTLTexture>)texture
                                           sampleCount:(int)sampleCount
                                               msaaTex:(id <MTLTexture>)msaaTex
                                                device:(id <MTLDevice>)device;


+ (MTLRenderPassAttachmentDescriptor *)depthAttachment:(id <MTLTexture>)texture
                                           sampleCount:(int)sampleCount
                                              depthTex:(id <MTLTexture>)depthTex
                                                device:(id <MTLDevice>)device
                                      depthPixelFormat:(MTLPixelFormat)depthPixelFormat;


+ (MTLRenderPassAttachmentDescriptor *)stencilAttachment:(id <MTLTexture>)texture
                                             sampleCount:(int)sampleCount
                                              stencilTex:(id <MTLTexture>)stencilTex
                                                  device:(id <MTLDevice>)device
                                      stencilPixelFormat:(MTLPixelFormat)stencilPixelFormat;


@property (nonatomic, readonly) id <MTLDevice> device;
@property (nonatomic, readonly) id <CAMetalDrawable> currentDrawable;
@property (nonatomic) CGSize drawableSize;
@property (nonatomic, readonly) MTLRenderPassDescriptor *renderPassDescriptor;

@property (nonatomic) MTLPixelFormat depthPixelFormat;
@property (nonatomic) MTLPixelFormat stencilPixelFormat;
@property (nonatomic) NSUInteger     sampleCount;

@property (nonatomic) BOOL layerSizeDidUpdate;

- (instancetype)initWithMetalView:(MetalView *)metalView;

- (void)releaseTextures;

- (void)display;

@end
