//
//  Shaders.metal
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/22/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Uniforms{
    float4 modelViewMatrixColumns[4];
};

struct Vertex{
    float4 position;
    float4 color;
};

struct VertexOut
{
    float4 position [[position]];
    float4 color;
};

float4x4 mv_MatrixFromUniformBuffer(global const Uniforms*  uniformMatrix)
{
    float4x4 matrix;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            matrix[j][i] = uniformMatrix[0].modelViewMatrixColumns[i][j];
        }
    }
    return matrix;
}

vertex VertexOut myVertexShader(const    global Vertex*    vertexArray   [[buffer(0)]],
                                const    global Uniforms*  uniforms      [[buffer(1)]],
                                unsigned        int        vid           [[vertex_id]])
{
    float4x4 mv_Matrix = mv_MatrixFromUniformBuffer(uniforms);
    
    VertexOut out;
    out.position = mv_Matrix * vertexArray[vid].position;
    out.color = vertexArray[vid].color;
    return out;
}


fragment float4 myFragmentShader(VertexOut interpolated [[stage_in]])
{
    return interpolated.color;
}

