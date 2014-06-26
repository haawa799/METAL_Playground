//
//  UniformsBufferGenerator.h
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@class Matrix4x4;

@interface UniformsBufferGenerator : NSObject

+ (id <MTLBuffer>)generateUniformBuffer:(Matrix4x4 *)matrix
                                 device:(id <MTLDevice>)device;

@end
