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
    
    var cube: Cube!
    var baseEffect: BaseEffect!
    
    deinit{
        tearDownMetal()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var font = UIApplication.sharedApplication()

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
        baseEffect.ambientIntensity = 0.4
        baseEffect.diffuseIntensity = 0.8
        baseEffect.lightDirection = [0.0,1.0,-1.0]
        baseEffect.specularIntensity = 2.0
        baseEffect.shininess = 8.0
        
        var ratio: Float = Float(self.view.bounds.size.width) / Float(self.view.bounds.size.height)
        baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: ratio, nearZ: 1.0, farZ: 150.0)
        
        cube = Cube(baseEffect: baseEffect)
        renderPipeline = baseEffect.compile()
    }
    
    func tearDownMetal(){
        commandQ = nil
        renderPipeline = nil
        cube = nil
        baseEffect = nil
    }
    
    func update(delta: CFTimeInterval){
        //Draw
        var metalLayer:CAMetalLayer? = self.view.layer as? CAMetalLayer
        
        if let mLayer = metalLayer
        {
            var drawable = mLayer.newDrawable()
            var matrix: Matrix4 = Matrix4()
            matrix.translate(0, y: 0, z: -5)
            matrix.rotateAroundX(Matrix4.degreesToRad(20.0), y: 0, z: 0)
            cube.render(commandQ, drawable: drawable, parentMVMatrix: matrix)
        }
        
        cube.updateWithDelta(delta)
    }
}
