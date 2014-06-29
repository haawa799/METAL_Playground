//
//  UniformsBufferGenerator.m
//  Triangle
//
//  Created by Andrew K. on 6/26/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "UniformsBufferGenerator.h"
#import "Textured_Cube-Swift.h"

static const long kMaxBufferBytesPerFrame = 1024*1024;
static const int  kFloatsPerMatrix4       = 16;

@interface UniformsBufferGenerator()

@property(nonatomic,readwrite) int indexOfAvaliableBuffer;
@property(nonatomic,readwrite) int numberOfInflightBuffers;

@property(nonatomic,strong) NSArray *buffers;

@end

@implementation UniformsBufferGenerator


- (instancetype)initWithNumberOfInflightBuffers:(int)inflightBuffersCount
                                     withDevice:(id <MTLDevice>)device
{
    self = [super init];
    if(self != nil)
    {
        self.numberOfInflightBuffers = inflightBuffersCount;
        self.indexOfAvaliableBuffer = 0;
        
        NSMutableArray *mBuffers = [[NSMutableArray alloc] initWithCapacity:inflightBuffersCount];
        for (int i = 0; i < inflightBuffersCount; i++)
        {
            id <MTLBuffer> buffer = [device newBufferWithLength:kMaxBufferBytesPerFrame options:0];
            buffer.label = [NSString stringWithFormat:@"Uniform buffer #%@",@(i)];
            [mBuffers addObject:buffer];
        }
        self.buffers = mBuffers;
    }
    return self;
}

- (id <MTLBuffer>)bufferWithProjectionMatrix:(Matrix4 *)projMatrix
                             modelViewMatrix:(Matrix4 *)mvMatrix
{
    
    
    float uniformFloatsBuffer[kFloatsPerMatrix4 * 2];
    for (int k = 0; k < 2; k++)
    {
        for (int i = 0; i < 16; i++)
        {
            if(k == 0)
            {
                uniformFloatsBuffer[16*k + i] = mvMatrix->glkMatrix.m[i];
            }
            else
            {
                uniformFloatsBuffer[16*k + i] = projMatrix->glkMatrix.m[i];
            }
        }
    }
    
    id <MTLBuffer> uniformBuffer = self.buffers[self.indexOfAvaliableBuffer++];
    if(self.indexOfAvaliableBuffer == self.numberOfInflightBuffers)
    {
        self.indexOfAvaliableBuffer = 0;
    }
    uint8_t *bufferPointer = (uint8_t *)[uniformBuffer contents];
    
    // 1st box
    memcpy(bufferPointer, &uniformFloatsBuffer, sizeof(uniformFloatsBuffer));
    bufferPointer += sizeof(uniformFloatsBuffer);
    
    return uniformBuffer;
}

@end
