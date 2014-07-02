//
//  MetalView.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import QuartzCore

@objc protocol MetalViewProtocol
{
    func update(metalView : MetalView ,delta: CFTimeInterval)
    func reshape(metalView : MetalView)
}

@objc class MetalView: UIView
{
    //Public API
    var metalViewDelegate: MetalViewProtocol?
    
    func setFPSLabelHidden(hidden: Bool){
        if let label = fpsLabel{
            label.hidden = hidden
        }
        
    }
    
    func pause(){
        if let link = displayLink{
            link.paused = true
        }
    }
    
    func resume(){
        if let link = displayLink{
            link.paused = false
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
    
    //Private
    var displayLink: CADisplayLink?
    var lastFrameTimestamp: CFTimeInterval?
    var fpsLabel: UILabel?
    
    override class func layerClass() -> AnyClass{
        return CAMetalLayer.self
    }
    
    override func layoutSubviews()
    {
        var rightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1.0, constant: 0.0)
        var botConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        var heightConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
        var widthConstraint = NSLayoutConstraint(item: fpsLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        
        self.addConstraints([rightConstraint,botConstraint,widthConstraint,heightConstraint])
        super.layoutSubviews()
    }
    
    func setup(){
        fpsLabel = UILabel(frame: CGRectZero)
        fpsLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        fpsLabel!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        self.addSubview(fpsLabel)
        
        displayLink = CADisplayLink(target: self, selector: Selector.convertFromStringLiteral("drawCall:"))
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    func drawCall(displayLink: CADisplayLink){
        if lastFrameTimestamp == nil{
            lastFrameTimestamp = displayLink.timestamp
        }
        
        var elapsed:CFTimeInterval = displayLink.timestamp - lastFrameTimestamp!
        
        if fpsLabel?.hidden == false{
            var fps = 1.0 / elapsed
            fpsLabel!.text = "fps: \(Int(fps))"
        }
        lastFrameTimestamp = displayLink.timestamp
        
        metalViewDelegate?.update(self, delta: elapsed)
        
    }
    

}
