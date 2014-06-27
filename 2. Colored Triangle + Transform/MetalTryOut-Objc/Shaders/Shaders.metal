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
    float4 projectionMatrixColumns[4];
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

float4x4 mv_MatrixFromUniformBuffer(constant Uniforms&  uniformMatrix)
{
    float4x4 matrix;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            matrix[j][i] = uniformMatrix.modelViewMatrixColumns[j][i];
        }
    }
    return matrix;
}

float4x4 proj_MatrixFromUniformBuffer(constant Uniforms&  uniformMatrix)
{
    float4x4 matrix;
    for (int i = 0; i < 4; i++)
    {
        for (int j = 0; j < 4; j++)
        {
            matrix[j][i] = uniformMatrix.projectionMatrixColumns[j][i];
        }
    }
    return matrix;
}

vertex VertexOut myVertexShader(const    global Vertex*    vertexArray   [[buffer(0)]],
                                constant        Uniforms&  uniforms      [[buffer(1)]],
                                unsigned        int        vid           [[vertex_id]])
{
    float4x4 mv_Matrix = mv_MatrixFromUniformBuffer(uniforms);
    float4x4 proj_Matrix = proj_MatrixFromUniformBuffer(uniforms);
    float4 position = vertexArray[vid].position;
    
    VertexOut out;
    out.position = proj_Matrix * mv_Matrix * position;
    out.color = vertexArray[vid].color;
    return out;
}


fragment float4 myFragmentShader(VertexOut interpolated [[stage_in]])
{
    return interpolated.color;
}

