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
        
        
        var renderPathDescriptor = metalView.frameBuffer.renderPassDescriptor
        var commandBuffer = commandQueue.commandBuffer()
        commandBuffer.addCompletedHandler(
            {
                (buffer:MTLCommandBuffer!) -> Void in
                var q = dispatch_semaphore_signal(self.avaliableUniformBuffers)
            })
        
        
        var shouldEndEncodingOnLastChild = vertexCount <= 0
        var commandEncoder: MTLRenderCommandEncoder? = nil
        
        for var i = 0; i < children.count; i++
        {
            var child = children[i]
            var lastChild = i == children.count - 1
            commandEncoder = renderNode(child, parentMatrix: myModelViewMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPathDescriptor, commandBuffer: commandBuffer, encoder: commandEncoder)
        }
        
        if vertexCount > 0
        {
            commandEncoder = renderNode(self, parentMatrix: parentModelViewMatrix, projectionMatrix: projectionMatrix, renderPassDescriptor: renderPathDescriptor, commandBuffer: commandBuffer, encoder: commandEncoder)
        }
        
        commandBuffer.presentDrawable(metalView.frameBuffer.currentDrawable)
        
        commandEncoder?.endEncoding()
        
        // Commit commandBuffer to his commandQueue in which he will be executed after commands before him in queue
        commandBuffer.commit();
    }
}
