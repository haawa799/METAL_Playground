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
    
    init(device:MTLDevice ,vertexShaderName: String, fragmentShaderName:String)
    {
        self.device = device
        
        // Setup MTLRenderPipline descriptor object with vertex and fragment shader
        pipeLineDescriptor = MTLRenderPipelineDescriptor();
        var library = device.newDefaultLibrary();
        pipeLineDescriptor.vertexFunction = library.newFunctionWithName(vertexShaderName);
        pipeLineDescriptor.fragmentFunction = library.newFunctionWithName(fragmentShaderName);
        pipeLineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.FormatBGRA8Unorm;
//        BaseEffectSfiftFixer.setup(pipeLineDescriptor)
        
        super.init()
    }
    
    func compile() -> MTLRenderPipelineState?
    {
        // Compile the MTLRenderPipline object into immutable and cheap for use MTLRenderPipelineState
        renderPipelineState = device.newRenderPipelineStateWithDescriptor(pipeLineDescriptor, error: nil);
        return renderPipelineState
    }
}
