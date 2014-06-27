//
//  Cube.swift
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc class Cube: Model {
    
    init(baseEffect: BaseEffect)
    {
        var A = Vertex(x: -1.0, y:  1.0, z:  1.0, w: 1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        var B = Vertex(x: -1.0, y: -1.0, z:  1.0, w: 1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0)
        var C = Vertex(x:  1.0, y: -1.0, z:  1.0, w: 1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        var D = Vertex(x:  1.0, y:  1.0, z:  1.0, w: 1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0)
        
        var Q = Vertex(x: -1.0, y:  1.0, z: -1.0, w: 1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        var R = Vertex(x:  1.0, y:  1.0, z: -1.0, w: 1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0)
        var S = Vertex(x: -1.0, y: -1.0, z: -1.0, w: 1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        var T = Vertex(x:  1.0, y: -1.0, z: -1.0, w: 1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0)
        
        var verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
            R,T,S ,Q,R,S,   //Back
            
            Q,S,B ,Q,B,A,   //Left
            D,C,T ,D,T,R,   //Right

            Q,A,D ,Q,D,R,   //Top
            B,S,T ,B,T,C    //Bot
        ]
        
        super.init(name: "Cube", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count)
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
        rotationZ += Float(M_PI) * Float(delta)
        rotationY += Float(M_PI) * Float(delta)
    }
}
