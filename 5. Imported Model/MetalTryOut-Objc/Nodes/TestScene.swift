//
//  TestScene.swift
//  Imported Model
//
//  Created by Andrew K. on 7/4/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

class TestScene: Scene {
    
    
    var sheeps: Array<Ram>
    let numberOfSheeps = 9
    
    init(baseEffect: BaseEffect)
    {
        sheeps = Array()
        
        super.init(name: "TestScene", baseEffect: baseEffect)
        
        for var i = 0; i<numberOfSheeps; i++
        {
            var ram = Ram(baseEffect: baseEffect)
            ram.name = "ram\(i)"
            children.append(ram)
            
            var row = i / 3
            var column = i - (3 * row)
            var yDelta:Float = 4.0 / 4.0
            var xDelta:Float = 2.0 / 3
            
            ram.positionY = -1.0 + Float(yDelta) * Float(row)
            ram.positionX = -0.5 + Float(xDelta) * Float(column)
            ram.scale = 0.5
        }
        
        positionX = 0
        positionY = 0
        positionZ = -4
        scale = 1.3
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
    }    
    
}
