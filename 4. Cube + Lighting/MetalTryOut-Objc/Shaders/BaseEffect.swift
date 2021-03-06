//
//  BaseEffect.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import Metal

@objc class BaseEffect: NSObject
{
    var device:MTLDevice
    var renderPipelineState:MTLRenderPipelineState?
    var pipeLineDescriptor:MTLRenderPipelineDescriptor
    var projectionMatrix:AnyObject = Matrix4()
    
    var lightColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var lightDirection: [Float] = [0.0,0.0,0.0]
    var diffuseIntensity: Float = 1.0
    var ambientIntensity: Float = 1.0
    var specularIntensity: Float = 1.0
    var shininess: Float = 1.0
    
    init(device:MTLDevice ,vertexShaderName: String, fragmentShaderName:String)
    {
        self.device = device
        
        // Setup MTLRenderPipline descriptor object with vertex and fragment shader
        pipeLineDescriptor = MTLRenderPipelineDescriptor();
        var library = device.newDefaultLibrary();
        pipeLineDescriptor.vertexFunction = library.newFunctionWithName(vertexShaderName);
        pipeLineDescriptor.fragmentFunction = library.newFunctionWithName(fragmentShaderName);
        pipeLineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.BGRA8Unorm;
        
        super.init()
    }
    
    func compile() -> MTLRenderPipelineState?
    {
        // Compile the MTLRenderPipline object into immutable and cheap for use MTLRenderPipelineState
        renderPipelineState = device.newRenderPipelineStateWithDescriptor(pipeLineDescriptor, error: nil);
        return renderPipelineState
    }
}
