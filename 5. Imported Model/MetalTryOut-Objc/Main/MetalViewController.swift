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
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    var metalView: MetalView!
    
    let device: MTLDevice = MTLCreateSystemDefaultDevice()
    var commandQ: MTLCommandQueue!
    var renderPipeline: MTLRenderPipelineState!
    
    var fpsLabel: UILabel!
    
    
    //Private
    var _displayLink: CADisplayLink!
    var _lastFrameTimestamp: CFTimeInterval!
    var _gameLoopPaused: Bool!
    
    
    deinit{
        tearDownMetal()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        metalView = self.view as? MetalView
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
        
        _displayLink = CADisplayLink(target: self, selector: Selector.convertFromStringLiteral("newFrame:"))
        _displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func tearDownMetal(){
        commandQ = nil
        renderPipeline = nil
    }

    
    func newFrame(displayLink: CADisplayLink){
        
        if _lastFrameTimestamp == nil
        {
            _lastFrameTimestamp = displayLink.timestamp
        }
        
        var elapsed:CFTimeInterval = displayLink.timestamp - _lastFrameTimestamp
        metalView.fpsLabel!.text = "fps: \(Int(1.0/elapsed))"
        _lastFrameTimestamp = displayLink.timestamp
        metalView.display()
        
        update(elapsed)
    }
    
    func update(elapsed: CFTimeInterval)
    {
        
    }
}
