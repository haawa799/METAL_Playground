//
//  Model.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

@objc class Model: NSObject
{
    var baseEffect: BaseEffect
    let name: String
    var vertexCount: Int
    
    var vertexBuffer: MTLBuffer?
    
    init(name: String,
        baseEffect: BaseEffect,
        vertices: Array<Vertex>,
        vertexCount: Int)
    {
        self.name = name
        self.baseEffect = baseEffect
        self.vertexCount = vertexCount
        
        super.init()
        
        self.vertexBuffer = generateVertexBuffer(vertices, vertexCount: vertexCount, device: baseEffect.device)
    }
    
    func render(commandQueue: MTLCommandQueue, drawable: CAMetalDrawable)
    {
        var commandBuffer = commandQueue.commandBuffer()
        
        
        // MTLRenderPassDescriptor object represents a collection of configurable states
        var renderPassDesc:MTLRenderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDesc.colorAttachments[0].texture = drawable.texture
        renderPassDesc.colorAttachments[0].loadAction = MTLLoadAction.Clear
//        renderPassDesc.colorAttachments[0].clearValue = MTLClearColor(red: 0.0, green: 104.0/255, blue: 55.0/255, alpha: 1)
        
        // Create MTLRenderCommandEncoder object which translates all states into a command for GPU
        var commandEncoder:MTLRenderCommandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
        commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        commandEncoder.drawPrimitives(MTLPrimitiveType.Triangle, vertexStart: 0, vertexCount: vertexCount);
        commandEncoder.endEncoding();
        
        // After command in command buffer is encoded for GPU we provide drawable that will be invoked when this command buffer has been scheduled for execution
        if let drawableAnyObject = drawable as? MTLDrawable
        {
            commandBuffer.presentDrawable(drawableAnyObject);
        }
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
        
    }
    
    func generateVertexBuffer(vertices: Array<Vertex>, vertexCount: Int, device: MTLDevice) -> MTLBuffer?
    {
        vertexBuffer = VertexBufferGenerator.generateBufferVertices(vertices, vertexCount: vertexCount, device: device)
        return vertexBuffer
    }
}
