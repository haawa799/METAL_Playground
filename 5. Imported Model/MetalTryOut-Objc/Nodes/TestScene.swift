//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class TestScene: Node {
    
    let ram: Ram
    let ram1: Ram
    
    init(baseEffect: BaseEffect)
    {
        ram = Ram(baseEffect: baseEffect)
        ram1 = Ram(baseEffect: baseEffect)
        super.init(name: "TestScene", baseEffect: baseEffect, vertices: nil, vertexCount: 0, textureName: nil)
        
        children.append(ram)
        children.append(ram1)
        
        ram.scale = 0.5
        ram1.scale = 0.5
        ram1.name = "ram1"
        ram.positionY = -2
        ram1.positionY = 2
        
        positionX = 0
        positionY = 0
        positionZ = -3
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
        rotationY += Float(M_PI/8) * Float(delta)
    }
    
    override func render(commandQueue: MTLCommandQueue, metalView: MetalView, parentMVMatrix: AnyObject)
    {
        for child in children
        {
            child.render(commandQueue, metalView: metalView, parentMVMatrix: modelMatrix())
        }
    }
    
}
