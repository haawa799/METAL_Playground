//
//  MetalViewController.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//


import UIKit
import QuartzCore
import Metal

class MetalViewController: UIViewController,MetalViewProtocol {
    
    var metalView: MetalView!
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()
    var commandQ: MTLCommandQueue!
    var renderPipeline: MTLRenderPipelineState!
    
    var triangle:Triangle!
    var baseEffect: BaseEffect!
    
    deinit{
        tearDownMetal()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalView = self.view as? MetalView
        metalView.metalViewDelegate = self
        setupMetal()
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        metalView.resume()
    }
    
    override func viewDidDisappear(animated: Bool){
        super.viewDidDisappear(animated)
        metalView.pause()
    }
    
    func setupMetal(){
        commandQ = device.newCommandQueue()
        baseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        triangle = Triangle(baseEffect: baseEffect!)
        renderPipeline = baseEffect.compile()
    }
    
    func tearDownMetal(){
        commandQ = nil
        renderPipeline = nil
        triangle = nil
        baseEffect = nil
    }
    
    func update(delta: CFTimeInterval){
        //Draw
        var metalLayer:CAMetalLayer? = self.view.layer as? CAMetalLayer
        
        if let mLayer = metalLayer
        {
            var drawable = mLayer.newDrawable()
            triangle.render(commandQ, drawable: drawable)
        }
    }
}
