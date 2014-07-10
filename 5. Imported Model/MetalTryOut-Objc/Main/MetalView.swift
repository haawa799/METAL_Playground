//
//  MetalView.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import QuartzCore
import Metal

@objc protocol MetalViewProtocol
{
    func render(metalView : MetalView)
    func reshape(metalView : MetalView)
}

@objc class MetalView: UIView
{
    //Public API
    
    var metalViewDelegate: MetalViewProtocol?
    var frameBuffer: AnyObject!
    
    func setFPSLabelHidden(hidden: Bool){
        if let label = fpsLabel{
            label.hidden = hidden
        }
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        setup()
    }
    init(coder aDecoder: NSCoder!){
        super.init(coder: aDecoder)
        setup()
    }
    
    func display()
    {
        var frameBuf = frameBuffer as FrameBuffer
        
        frameBuf.drawableSize = self.bounds.size
        
        frameBuf.drawableSize.width  *= self.contentScaleFactor;
        frameBuf.drawableSize.height *= self.contentScaleFactor;
        
        var size = self.bounds.size
        
        size.width  *= self.contentScaleFactor
        size.height *= self.contentScaleFactor
        
        frameBuf.displayWithDrawableSize(size)
    }
    
    
    //Private
    var lastFrameTimestamp: CFTimeInterval?
    var _metalLayer: CAMetalLayer!
    var fpsLabel: UILabel?
    
    
    override class func layerClass() -> AnyClass{
        return CAMetalLayer.self
    }
    override func layoutSubviews(){
        var rightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)
        var botConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        var heightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
        var widthConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        
        self.addConstraints([rightConstraint,botConstraint,widthConstraint,heightConstraint])
        
        (frameBuffer as FrameBuffer).layerSizeDidUpdate = true
        
        super.layoutSubviews()
    }
    
    func setup(){
    
        fpsLabel = UILabel(frame: CGRectZero)
        fpsLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        fpsLabel!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        self.addSubview(fpsLabel)

        
        self.opaque          = true
        self.backgroundColor = nil
        
        // setting this to yes will allow Main thread to display framebuffer when
        // view:setNeedDisplay: is called by main thread
        _metalLayer = self.layer as CAMetalLayer
        
        self.contentScaleFactor = UIScreen.mainScreen().scale
        
        _metalLayer.presentsWithTransaction = false
        _metalLayer.drawsAsynchronously     = true
        
        var device = MTLCreateSystemDefaultDevice()
        
        _metalLayer.device          = device
        _metalLayer.pixelFormat     = MTLPixelFormat.BGRA8Unorm
        _metalLayer.framebufferOnly = true
        
        frameBuffer = FrameBuffer(metalView: self)
    }
}
