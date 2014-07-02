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
    var texture: MTLTexture?
    var depthState: MTLDepthStencilState?
    
    var positionX:Float = 0.0
    var positionY:Float = 0.0
    var positionZ:Float = 0.0
    
    var rotationX:Float = 0.0
    var rotationY:Float = 0.0
    var rotationZ:Float = 0.0
    var scale:Float     = 1.0
    
    var vertexBuffer: MTLBuffer?
    var uniformBufferGenerator: AnyObject
    var uniformsBuffer: MTLBuffer?
    var samplerState: MTLSamplerState?
    
    var diffuseIntensity: Float = 1.0
    var ambientIntensity: Float = 1.0
    var specularIntensity: Float = 1.0
    var shininess: Float = 1.0
    
    var avaliableUniformBuffers = dispatch_semaphore_create(3)
    
    init(name: String,
        baseEffect: BaseEffect,
        vertices: Array<Vertex>,
        vertexCount: Int,
        textureName: String)
    {
        var mTexture:METLTexture = METLTexture(resourceName: textureName.pathComponents[0], ext: textureName.pathComponents[1])
        mTexture.finalize(baseEffect.device)
        
        self.name = name
        self.baseEffect = baseEffect
        self.vertexCount = vertexCount
        self.texture = mTexture.texture
        self.uniformBufferGenerator = UniformsBufferGenerator(numberOfInflightBuffers: 3, withDevice: baseEffect.device)
        
        super.init()
        
        self.vertexBuffer = generateVertexBuffer(vertices, vertexCount: vertexCount, device: baseEffect.device)
        self.samplerState = generateSamplerStateForTexture(baseEffect.device)
        
        var depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = MTLCompareFunction.Less
        depthStateDesc.depthWriteEnabled = true
        depthState = baseEffect.device.newDepthStencilStateWithDescriptor(depthStateDesc)
    }
    
    func render(commandQueue: MTLCommandQueue, metalView: MetalView, parentMVMatrix: AnyObject)
    {
        
        var parentModelViewMatrix: Matrix4 = parentMVMatrix as Matrix4
        var myModelViewMatrix: Matrix4 = modelMatrix() as Matrix4
        myModelViewMatrix.multiplyLeft(parentModelViewMatrix)
        var projectionMatrix: Matrix4 = baseEffect.projectionMatrix as Matrix4
        self.uniformsBuffer = getUniformsBuffer(myModelViewMatrix, projMatrix: projectionMatrix, baseEffect: baseEffect)
        
        
        //We are using 3 uniform buffers, we need to wait in case CPU wants to write in first uniform buffer, while GPU is still using it (case when GPU is 2 frames ahead CPU)
        dispatch_semaphore_wait(avaliableUniformBuffers, DISPATCH_TIME_FOREVER)
        
        var commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler(
        {
            (buffer:MTLCommandBuffer!) -> Void in
            var q = dispatch_semaphore_signal(self.avaliableUniformBuffers)
        })
        
        
        // Create MTLRenderCommandEncoder object which translates all states into a command for GPU
        var renderPathDescriptor = metalView.renderPassDescriptor
        
        var commandEncoder:MTLRenderCommandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPathDescriptor)
        commandEncoder.setDepthStencilState(depthState)
        
        commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState)
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
        commandEncoder.setVertexBuffer(uniformsBuffer, offset: 0, atIndex: 1)
        commandEncoder.setFragmentTexture(self.texture, atIndex: 0)
        commandEncoder.setFragmentSamplerState(self.samplerState, atIndex: 0)
        commandEncoder.setCullMode(MTLCullMode.Front)
        commandEncoder.drawPrimitives(MTLPrimitiveType.Triangle, vertexStart: 0, vertexCount: vertexCount)
        commandEncoder.endEncoding()
        
        // After command in command buffer is encoded for GPU we provide drawable that will be invoked when this command buffer has been scheduled for execution
        if let drawableAnyObject = metalView.currentDrawable as? MTLDrawable
        {
            commandBuffer.presentDrawable(drawableAnyObject);
        }
        
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
    
    func generateSamplerStateForTexture(device: MTLDevice) -> MTLSamplerState?
    {
        var pSamplerDescriptor:MTLSamplerDescriptor? = MTLSamplerDescriptor();
        
        if let sampler = pSamplerDescriptor
        {
            sampler.minFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.magFilter             = MTLSamplerMinMagFilter.Nearest
            sampler.mipFilter             = MTLSamplerMipFilter.NotMipmapped
            sampler.maxAnisotropy         = 1
            sampler.sAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.tAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.rAddressMode          = MTLSamplerAddressMode.ClampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp           = 0
            sampler.lodMaxClamp           = FLT_MAX
        }
        else
        {
            println(">> ERROR: Failed creating a sampler descriptor!")
        }
        
        return device.newSamplerStateWithDescriptor(pSamplerDescriptor)
    }
    
    // Two following methods are used as a glue for Objective-C buffer generator code and Swift code
    func getUniformsBuffer(mvMatrix: AnyObject, projMatrix: AnyObject,baseEffect: BaseEffect) -> MTLBuffer?
    {
        var mv:Matrix4 = mvMatrix as Matrix4
        var proj:Matrix4 = projMatrix as Matrix4
        var generator: UniformsBufferGenerator = self.uniformBufferGenerator as UniformsBufferGenerator
        uniformsBuffer = generator.bufferWithProjectionMatrix(proj, modelViewMatrix: mv, withBaseEffect: baseEffect, withModel: self)
        return uniformsBuffer
    }
    
    func generateVertexBuffer(vertices: Array<Vertex>, vertexCount: Int, device: MTLDevice) -> MTLBuffer?
    {
        vertexBuffer = VertexBufferGenerator.generateBufferVertices(vertices, vertexCount: vertexCount, device: device)
        return vertexBuffer
    }
}
