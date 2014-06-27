//
//  Square.swift
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc class Square: Model {
    
    init(baseEffect: BaseEffect)
    {
        var A = Vertex(x: -1.0, y:  1.0, z: 0.0, w: 1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        var B = Vertex(x: -1.0, y: -1.0, z: 0.0, w: 1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0)
        var C = Vertex(x:  1.0, y: -1.0, z: 0.0, w: 1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        var D = Vertex(x:  1.0, y:  1.0, z: 0.0, w: 1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0)
        
        var verticesArray:Array<Vertex> = [A,B,C ,A,C,D]
        
        super.init(name: "Square", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count)
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
        var secsPerMove: Float = 2.0
        positionX = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
    }
}
