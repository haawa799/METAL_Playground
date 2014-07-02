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
    
    var monkey: Monkey!
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
        
        _displayLink = CADisplayLink(target: self, selector: Selector.convertFromStringLiteral("update:"))
        _displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        fpsLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 60))
        metalView.addSubview(fpsLabel)
        fpsLabel.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        
        metalView.depthPixelFormat   = MTLPixelFormat.FormatDepth32Float
        metalView.stencilPixelFormat = MTLPixelFormat.FormatInvalid
        metalView.sampleCount        = 4
        
        commandQ = device.newCommandQueue()
        baseEffect = BaseEffect(device: device, vertexShaderName: "myVertexShader", fragmentShaderName: "myFragmentShader")
        baseEffect.lightDirection = [0.0,1.0,-1.0]
        
        var ratio: Float = Float(self.view.bounds.size.width) / Float(self.view.bounds.size.height)
        baseEffect.projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degreesToRad(85.0), aspectRatio: ratio, nearZ: 1.0, farZ: 150.0)
        
        monkey = Monkey(baseEffect: baseEffect)
        monkey.ambientIntensity = 0.4
        monkey.diffuseIntensity = 0.8
        monkey.specularIntensity = 2.0
        monkey.shininess = 8.0
        renderPipeline = baseEffect.compile()
    }
    
    func tearDownMetal(){
        commandQ = nil
        renderPipeline = nil
        monkey = nil
        baseEffect = nil
    }

    
    func update(displayLink: CADisplayLink){
        //Draw
        if _lastFrameTimestamp == nil
        {
            _lastFrameTimestamp = displayLink.timestamp
        }
        
        var elapsed:CFTimeInterval = displayLink.timestamp - _lastFrameTimestamp
        fpsLabel.text = "fps: \(1.0/elapsed)"
        _lastFrameTimestamp = displayLink.timestamp
        
        var metalLayer:CAMetalLayer? = self.view.layer as? CAMetalLayer
        
        if let mLayer = metalLayer
        {
            var drawable = mLayer.newDrawable
            var matrix: Matrix4 = Matrix4()
            matrix.translate(0, y: 0, z: -5)
            matrix.rotateAroundX(Matrix4.degreesToRad(20.0), y: 0, z: 0)
            monkey.render(commandQ, metalView: metalView, parentMVMatrix: matrix)
        }
        
        metalView.display()
        
        monkey.updateWithDelta(elapsed)
    }
}
