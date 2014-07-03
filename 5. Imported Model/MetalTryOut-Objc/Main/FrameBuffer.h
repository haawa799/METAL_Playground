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


@property (nonatomic, readonly) id <MTLDevice> device;
@property (nonatomic, readonly) id <CAMetalDrawable> currentDrawable;
@property (nonatomic, readonly) MTLRenderPassDescriptor *renderPassDescriptor;

@property (nonatomic) MTLPixelFormat depthPixelFormat;
@property (nonatomic) MTLPixelFormat stencilPixelFormat;
@property (nonatomic) NSUInteger     sampleCount;

// Change this value when layerSize changes (orientation change or when contens scale set)
@property (nonatomic) BOOL layerSizeDidUpdate;

// New drawable size must be reset before call display
@property (nonatomic) CGSize drawableSize;


- (instancetype)initWithMetalView:(MetalView *)metalView;
- (void)releaseTextures;
- (void)displayWithDrawableSize:(CGSize)drawableSize;

@end
