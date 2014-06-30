//
//  Shaders.metal
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/22/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Light{
    float4 color;
    float ambientIntensity;
};

struct Uniforms{
    float4 modelViewMatrixColumns[4];
    float4 projectionMatrixColumns[4];
    Light light;
};

struct Vertex{
    packed_float4 color;
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut
{
    float4 position [[position]];
    float4 color;
    float2 texCoord [[user(texturecoord)]];
    
    float4 ambientColor;
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
    //Get transformation matrices from uniform
    float4x4 mv_Matrix = mv_MatrixFromUniformBuffer(uniforms);
    float4x4 proj_Matrix = proj_MatrixFromUniformBuffer(uniforms);
    float4 position = {vertexArray[vid].position[0],vertexArray[vid].position[1],vertexArray[vid].position[2],1.0};
    
    //Get ambient color from uniform
    float4 ambientColor = uniforms.light.color;
    for (int i = 0; i<3; i++)
    {
        ambientColor[i] *= uniforms.light.ambientIntensity;
    }
    
    VertexOut out;
    out.position = proj_Matrix * mv_Matrix * position;
    out.color = vertexArray[vid].color;
    out.texCoord = vertexArray[vid].texCoord;
    out.ambientColor = ambientColor;
    return out;
}


fragment float4 myFragmentShader(VertexOut interpolated [[stage_in]],
                                 texture2d<float>  tex2D     [[ texture(0) ]],
                                 sampler           sampler2D [[ sampler(0) ]])
{
    
    return  /*interpolated.color */interpolated.ambientColor * tex2D.sample(sampler2D, interpolated.texCoord);
}

