//
//  Shaders.metal
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/22/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex{
    float4 position;
    float4 color;
};

struct VertexOut
{
    float4 position [[position]];
    float4 color;
};


vertex VertexOut myVertexShader(const global Vertex* vertexArray [[buffer(0)]],
                                unsigned int vid [[vertex_id]])
{
    VertexOut out;
    out.position = vertexArray[vid].position;
    out.color = vertexArray[vid].color;
    return out;
}


fragment float4 myFragmentShader(VertexOut interpolated [[stage_in]])
{
    return interpolated.color;
}

