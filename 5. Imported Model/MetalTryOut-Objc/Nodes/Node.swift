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


@objc class Node: NSObject
{
    class var numberOfUniformBuffersToUse:Int {
        return 3*10
    }
    
    var time:CFTimeInterval = 0.0
    
    var baseEffect: BaseEffect
    var name: String
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
    
    var children:Array<Node> = Array<Node>()
    
    var vertexBuffer: MTLBuffer?
    var uniformBufferGenerator: AnyObject
    var uniformsBuffer: MTLBuffer?
    var samplerState: MTLSamplerState?
    
    var diffuseIntensity: Float = 1.0
    var ambientIntensity: Float = 1.0
    var specularIntensity: Float = 1.0
    var shininess: Float = 1.0
    
    var avaliableUniformBuffers = dispatch_semaphore_create(numberOfUniformBuffersToUse)
    
    init(name: String,
        baseEffect: BaseEffect,
        vertices: Array<Vertex>?,
        vertexCount: Int,
        textureName: String?)
    {
        //Setup texture if present
        if let texName = textureName
        {
            var mTexture:METLTexture = METLTexture(resourceName: texName.pathComponents[0], ext: texName.pathComponents[1])
            mTexture.finalize(baseEffect.device)
            self.texture = mTexture.texture
        }
        
        self.name = name
        self.baseEffect = baseEffect
        self.vertexCount = vertexCount
        
        self.uniformBufferGenerator = UniformsBufferGenerator(numberOfInflightBuffers: CInt(Node.numberOfUniformBuffersToUse), withDevice: baseEffect.device)
        
        super.init()
        
        if let trueVertices = vertices
        {
            self.vertexBuffer = generateVertexBuffer(trueVertices, vertexCount: vertexCount, device: baseEffect.device)
        }
//        vertices.removeAll(keepCapacity: false)
        self.samplerState = generateSamplerStateForTexture(baseEffect.device)
        
        var depthStateDesc = MTLDepthStencilDescriptor()
        depthStateDesc.depthCompareFunction = MTLCompareFunction.Less
        depthStateDesc.depthWriteEnabled = true
        depthState = baseEffect.device.newDepthStencilStateWithDescriptor(depthStateDesc)
    }
    
    func renderNode(node: Node, parentMatrix: AnyObject, projectionMatrix: AnyObject, renderPassDescriptor: MTLRenderPassDescriptor, commandBuffer: MTLCommandBuffer, encoder: MTLRenderCommandEncoder?) -> MTLRenderCommandEncoder
    {
        var commandEncoder:MTLRenderCommandEncoder
        if let encoder = encoder
        {
            commandEncoder = encoder
        }
        else
        {
            commandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        }
        commandEncoder.setDepthStencilState(depthState)
        commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState)
        commandEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
        commandEncoder.setCullMode(MTLCullMode.Front)
        
        
        commandEncoder.pushDebugGroup(node.name)
        
        for child in node.children
        {
            child.renderNode(node, parentMatrix: parentMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer, encoder: commandEncoder)
        }
        
        var nodeModelMatrix: Matrix4 = node.modelMatrix() as Matrix4
        nodeModelMatrix.multiplyLeft(parentMatrix as Matrix4)
        var uniform = getUniformsBuffer(nodeModelMatrix, projMatrix: projectionMatrix, baseEffect: node.baseEffect)
        commandEncoder.setVertexBuffer(node.vertexBuffer, offset: 0, atIndex: 0)
        commandEncoder.setVertexBuffer(uniformsBuffer, offset: 0, atIndex: 1)
        commandEncoder.setFragmentTexture(node.texture, atIndex: 0)
        commandEncoder.drawPrimitives(MTLPrimitiveType.Triangle, vertexStart: 0, vertexCount: node.vertexCount)
        
        
        commandEncoder.popDebugGroup()
        
        return commandEncoder
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
        for child in children
        {
            child.updateWithDelta(delta)
        }
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
