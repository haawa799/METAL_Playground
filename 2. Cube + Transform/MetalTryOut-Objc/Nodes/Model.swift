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
    var time:CFTimeInterval = 0.0
    
    var baseEffect: BaseEffect
    let name: String
    var vertexCount: Int
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    
    var vertexBuffer: MTLBuffer?
    var uniformsBuffer: MTLBuffer?
    
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
    
    func render(commandQueue: MTLCommandQueue, drawable: CAMetalDrawable, parentMVMatrix: AnyObject)
    {
        var parentModelViewMatrix: Matrix4 = parentMVMatrix as Matrix4
        var myModelViewMatrix: Matrix4 = modelMatrix() as Matrix4
        myModelViewMatrix.multiplyLeft(parentModelViewMatrix)
        var projectionMatrix: Matrix4 = baseEffect.projectionMatrix as Matrix4
        self.uniformsBuffer = generateUniformsBuffer(myModelViewMatrix, projMatrix: projectionMatrix, device: baseEffect.device)
        
        var commandBuffer = commandQueue.commandBuffer()
        
        
        // MTLRenderPassDescriptor object represents a collection of configurable states
        var renderPassDesc:MTLRenderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDesc.colorAttachments[0].texture = drawable.texture
        renderPassDesc.colorAttachments[0].loadAction = MTLLoadAction.Clear
        
        // Create MTLRenderCommandEncoder object which translates all states into a command for GPU
        var commandEncoder:MTLRenderCommandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDesc)
        commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        commandEncoder.setVertexBuffer(uniformsBuffer, offset: 0, atIndex: 1)
        commandEncoder.setCullMode(MTLCullMode.Front)
        commandEncoder.drawPrimitives(MTLPrimitiveType.Triangle, vertexStart: 0, vertexCount: vertexCount);
        commandEncoder.endEncoding();
        
        // After command in command buffer is encoded for GPU we provide drawable that will be invoked when this command buffer has been scheduled for execution
        commandBuffer.presentDrawable(drawable);
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
        
    }
    
    func modelMatrix() -> AnyObject //AnyObject is used as a workaround against comiler error, waiting for fix in following betas
    {
        var matrix = Matrix4()
        matrix.translate(positionX, y: positionY, z: positionZ)
        matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
        matrix.scale(scale, y: scale, z: scale)
        return matrix
    }
    
    func updateWithDelta(delta: CFTimeInterval)
    {
        time += delta
    }
    
    // Two following methods are used as a glue for Objective-C buffer generator code and Swift code
    
    func generateUniformsBuffer(mvMatrix: AnyObject, projMatrix: AnyObject, device: MTLDevice) -> MTLBuffer?
    {
        var mv:Matrix4 = mvMatrix as Matrix4
        var proj:Matrix4 = projMatrix as Matrix4
        
        uniformsBuffer = UniformsBufferGenerator.generateUniformBufferProjectionMatrix(proj, modelViewMatrix: mv, device: device)
        return uniformsBuffer
    }
    
    func generateVertexBuffer(vertices: Array<Vertex>, vertexCount: Int, device: MTLDevice) -> MTLBuffer?
    {
        vertexBuffer = VertexBufferGenerator.generateBufferVertices(vertices, vertexCount: vertexCount, device: device)
        return vertexBuffer
    }
}
