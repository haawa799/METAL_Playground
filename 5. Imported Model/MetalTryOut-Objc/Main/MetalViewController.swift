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

class MetalViewController: UIViewController {
    
    var metalView: MetalView!
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()
    var commandQ: MTLCommandQueue!
    var renderPipeline: MTLRenderPipelineState!
    
    var ram: Ram!
    var baseEffect: BaseEffect!
    
    var fpsLabel: UILabel!
    
    //Private
    
    
    var _displayLink: CADisplayLink!
    var _lastFrameTimestamp: CFTimeInterval!
    
    
    // pause/resume
    var _gameLoopPaused: Bool!
    
    
    deinit{
        tearDownMetal()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        metalView = self.view as? MetalView
//        metalView.delegate = self
        setupMetal()
    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool){
        super.viewDidDisappear(animated)
    }
    
    func setupMetal(){
        
        commandQ = device.newCommandQueue()
        baseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        baseEffect.lightDirection = [0.0,1.0,-1.0]
        
        var ratio: Float = Float(self.view.bounds.size.width) / Float(self.view.bounds.size.height)
        baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: ratio, nearZ: 1.0, farZ: 150.0)
        
        ram = Ram(baseEffect: baseEffect)
        ram.scale = 2.0
        ram.ambientIntensity = 0.4
        ram.diffuseIntensity = 0.8
        ram.specularIntensity = 2.0
        ram.shininess = 8.0
        ram.rotationX = Matrix4.degreesToRad(-90.0)
        renderPipeline = baseEffect.compile()
        
        _displayLink = CADisplayLink(target: self, selector: Selector.convertFromStringLiteral("update:"))
        _displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func tearDownMetal(){
        commandQ = nil
        renderPipeline = nil
        ram = nil
        baseEffect = nil
    }

    
    func update(displayLink: CADisplayLink){
        //Draw
        if _lastFrameTimestamp == nil
        {
            _lastFrameTimestamp = displayLink.timestamp
        }
        
        var elapsed:CFTimeInterval = displayLink.timestamp - _lastFrameTimestamp
        metalView.fpsLabel!.text = "fps: \(Int(1.0/elapsed))"
        _lastFrameTimestamp = displayLink.timestamp
        
        var metalLayer:CAMetalLayer? = self.view.layer as? CAMetalLayer
        
        if let mLayer = metalLayer
        {
            var drawable = mLayer.newDrawable
            var matrix: Matrix4 = Matrix4()
            matrix.translate(0, y: -1, z: -5)
            ram.render(commandQ, metalView: metalView, parentMVMatrix: matrix)
        }
        
        metalView.display()
        
        ram.updateWithDelta(elapsed)
    }
}
