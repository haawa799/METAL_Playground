//
//  VertexBufferGenerator.m
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "VertexBufferGenerator.h"
#import "Textured_Cube-Swift.h"

static const int kNumberOfPositionComponents = 4;
static const int kNumberOfColorComponents = 4;
static const int kNumberOfTextureComponents = 2;


@implementation VertexBufferGenerator

+ (id <MTLBuffer>)generateBufferVertices:(NSArray *)vertices
                             vertexCount:(NSNumber *)vertexCount
                                  device:(id <MTLDevice>)device
{
    float vertexData[(kNumberOfPositionComponents + kNumberOfColorComponents + kNumberOfTextureComponents)*vertexCount.intValue];
    int counter = 0;
    
    for (int vertexID = 0; vertexID < vertexCount.integerValue; vertexID++)
    {
        Vertex *vertex = vertices[vertexID];
        
        vertexData[counter++] = vertex.r;
        vertexData[counter++] = vertex.g;
        vertexData[counter++] = vertex.b;
        vertexData[counter++] = vertex.a;
        
        vertexData[counter++] = vertex.x;
        vertexData[counter++] = vertex.y;
        vertexData[counter++] = vertex.z;
        
        vertexData[counter++] = vertex.u;
        vertexData[counter++] = vertex.v;
    }
    
    id <MTLBuffer> vertexBuffer = [device newBufferWithBytes:vertexData length:sizeof(vertexData) options:0];
    
    return vertexBuffer;
}

@end
