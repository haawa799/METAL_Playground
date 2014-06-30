//
//  UniformsBufferGenerator.h
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import "Matrix4.h"

@class Matrix4x4;


/// This class is responsible for providing a uniformBuffer which will be passed to vertex shader. It holds n buffers. In case n == 3 for frame0 it will give buffer0 for frame1 - buffer1 for frame2 - buffer2 for frame3 - buffer0 and so on. It's user responsibility to make sure that GPU is not using that buffer before use. For details refer to wwdc session 604 (18:00).
@interface UniformsBufferGenerator : NSObject

@property(nonatomic,readonly) int indexOfAvaliableBuffer;
@property(nonatomic,readonly) int numberOfInflightBuffers;

- (instancetype)initWithNumberOfInflightBuffers:(int)inflightBuffersCount
                                     withDevice:(id <MTLDevice>)device;

- (id <MTLBuffer>)bufferWithProjectionMatrix:(Matrix4 *)projMatrix
                             modelViewMatrix:(Matrix4 *)mvMatrix
                              withLightColor:(MTLClearColor)lightColor
                        withAmbientIntensity:(float)ambientIntensity;

@end
