//
//  UniformsBufferGenerator.m
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "UniformsBufferGenerator.h"
#import "Cube_Transform-Swift.h"

@implementation UniformsBufferGenerator

+ (id <MTLBuffer>)generateUniformBufferProjectionMatrix:(Matrix4 *)projMatrix
                                        modelViewMatrix:(Matrix4 *)mvMatrix
                                                 device:(id <MTLDevice>)device
{
    float buffer[32];
    for (int k = 0; k < 2; k++)
    {
        for (int i = 0; i < 16; i++)
        {
            if(k == 0)
            {
                buffer[16*k + i] = mvMatrix->glkMatrix.m[i];
            }
            else
            {
                buffer[16*k + i] = projMatrix->glkMatrix.m[i];
            }
        }
    }
    
    id <MTLBuffer> uniformBuffer = [device newBufferWithBytes:buffer length:sizeof(buffer) options:0];
    return uniformBuffer;
}

@end
