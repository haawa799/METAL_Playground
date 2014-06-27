//
//  UniformsBufferGenerator.m
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "UniformsBufferGenerator.h"
#import "Triangle-Swift.h"

@implementation UniformsBufferGenerator

+ (id <MTLBuffer>)generateUniformBuffer:(Matrix4 *)matrix
                                 device:(id <MTLDevice>)device
{
    [matrix transpose];
    id <MTLBuffer> uniformBuffer = [device newBufferWithBytes:matrix->glkMatrix.m length:sizeof(matrix->glkMatrix.m) options:0];
    return uniformBuffer;
}

@end
