//
//  Scene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class Scene: Node {
    
    init(name: String, baseEffect: BaseEffect)
    {
        super.init(name: name, baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
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
        var renderPathDescriptor = metalView.frameBuffer.renderPassDescriptor
        
        var commandEncoder:MTLRenderCommandEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPathDescriptor)
        commandEncoder.setDepthStencilState(depthState)
        commandEncoder.setRenderPipelineState(baseEffect.renderPipelineState)
        commandEncoder.setFragmentSamplerState(samplerState, atIndex: 0)
        commandEncoder.setCullMode(MTLCullMode.Front)
        //
        
        for child in children
        {
            renderNode(child, parentMatrix: myModelViewMatrix, projectionMatrix: projectionMatrix, commandEncoder: commandEncoder, frameUniformsBuffer: uniformsBuffer!)
        }
        
        if vertexCount > 0
        {
            renderNode(self, parentMatrix: parentModelViewMatrix, projectionMatrix: projectionMatrix, commandEncoder: commandEncoder, frameUniformsBuffer: uniformsBuffer!)
        }
        
        commandEncoder.endEncoding()
        
        // After command in command buffer is encoded for GPU we provide drawable that will be invoked when this command buffer has been scheduled for execution
        if let drawableAnyObject = metalView.frameBuffer.currentDrawable as? MTLDrawable
        {
            commandBuffer.presentDrawable(drawableAnyObject);
        }
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
    }
}
