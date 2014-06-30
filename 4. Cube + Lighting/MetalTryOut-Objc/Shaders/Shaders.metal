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
    float4        color;
    packed_float3 direction;
    float         ambientIntensity;
    float         diffuseIntensity;
};

struct Uniforms{
    float4        modelViewMatrixColumns[4];
    float4        projectionMatrixColumns[4];
    Light         light;
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
    float3 normal;
    
    float3 lightDirection;
    float4 lightColor;
    float  diffuseIntensity;
    float  ambientIntensity;
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
    
    //Get normal
    float4 normal;
    if (vid < 6)
    {
        normal = {0.0,0.0,1.0,0.0};
    }
    else if (vid < 12)
    {
        normal = {0.0,0.0,-1.0,0.0};
    }
    else if (vid < 18)
    {
        normal = {-1.0,0.0,0.0,0.0};
    }
    else if (vid < 24)
    {
        normal = {1.0,0.0,0.0,0.0};
    }
    else if (vid < 30)
    {
        normal = {0.0,1.0,0.0,0.0};
    }
    else
    {
        normal = {0.0,-1.0,0.0,0.0};
    }
    normal = mv_Matrix * normal;
    
    
    VertexOut out;
    out.position = proj_Matrix * mv_Matrix * position;
    out.color = vertexArray[vid].color;
    out.texCoord = vertexArray[vid].texCoord;
    out.normal = {normal[0],normal[1],normal[2]};
    
    out.lightDirection = uniforms.light.direction;
    out.lightColor = uniforms.light.color;
    out.diffuseIntensity = uniforms.light.diffuseIntensity;
    out.ambientIntensity = uniforms.light.ambientIntensity;
    
    return out;
}


fragment float4 myFragmentShader(VertexOut interpolated [[stage_in]],
                                 texture2d<float>  tex2D     [[ texture(0) ]],
                                 sampler           sampler2D [[ sampler(0) ]])
{
    float3 normal = normalize(interpolated.normal);
    float3 lightDirection = normalize(interpolated.lightDirection);
    
    //Get ambient color from uniform
    float4 ambientColor = interpolated.lightColor;
    for (int i = 0; i<3; i++)
    {
        ambientColor[i] *= interpolated.ambientIntensity;
    }
    
    //Get diffuse color
    float diffuseFactor = max(-dot(normal,lightDirection),0.0);
    float4 diffuseColor = {1.0,1.0,1.0,1.0};
    for (int i = 0; i<3; i++)
    {
        diffuseColor[i] *= diffuseFactor * interpolated.diffuseIntensity;
    }
    
    return (/*interpolated.color +*/ ambientColor + diffuseColor) * tex2D.sample(sampler2D, interpolated.texCoord);
}

