//
//  UniformsBufferGenerator.h
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import "Matrix4.h"

@class Matrix4x4;

@interface UniformsBufferGenerator : NSObject

+ (id <MTLBuffer>)generateUniformBufferProjectionMatrix:(Matrix4 *)projMatrix
                                        modelViewMatrix:(Matrix4 *)mvMatrix
                                                 device:(id <MTLDevice>)device;

@end
