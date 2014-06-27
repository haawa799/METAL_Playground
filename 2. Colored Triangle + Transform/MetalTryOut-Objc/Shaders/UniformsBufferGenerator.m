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
    float matrixData[16];
    for (int i = 0; i < 16; i++)
    {
        matrixData[i] = matrix->mat[i];
    }
    
    id <MTLBuffer> uniformBuffer = [device newBufferWithBytes:matrixData length:sizeof(matrixData) options:0];
    
    return uniformBuffer;
}

@end
