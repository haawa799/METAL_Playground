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
        //Front
        var V0  = Vertex(x:  1.0, y: -1.0, z:  1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 1.0 , v: 0.0)
        var V1  = Vertex(x:  1.0, y:  1.0, z:  1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 1.0 , v: 1.0)
        var V2  = Vertex(x: -1.0, y:  1.0, z:  1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 0.0 , v: 1.0)
        var V3  = Vertex(x: -1.0, y: -1.0, z:  1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 0.0 , v: 0.0)
        //Back
        var V4  = Vertex(x: -1.0, y: -1.0, z: -1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 1.0 , v: 0.0)
        var V5  = Vertex(x: -1.0, y:  1.0, z: -1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 1.0 , v: 1.0)
        var V6  = Vertex(x:  1.0, y:  1.0, z: -1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 0.0 , v: 1.0)
        var V7  = Vertex(x:  1.0, y: -1.0, z: -1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 0.0 , v: 0.0)
        //Left
        var V8  = Vertex(x: -1.0, y: -1.0, z:  1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 1.0 , v: 0.0)
        var V9  = Vertex(x: -1.0, y:  1.0, z:  1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 1.0 , v: 1.0)
        var V10 = Vertex(x: -1.0, y:  1.0, z: -1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 0.0 , v: 1.0)
        var V11 = Vertex(x: -1.0, y: -1.0, z: -1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 0.0 , v: 0.0)
        //Right
        var V12 = Vertex(x:  1.0, y: -1.0, z: -1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 1.0 , v: 0.0)
        var V13 = Vertex(x:  1.0, y:  1.0, z: -1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 1.0 , v: 1.0)
        var V14 = Vertex(x:  1.0, y:  1.0, z:  1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 0.0 , v: 1.0)
        var V15 = Vertex(x:  1.0, y: -1.0, z:  1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 0.0 , v: 0.0)
        //Top
        var V16 = Vertex(x:  1.0, y:  1.0, z:  1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 1.0 , v: 0.0)
        var V17 = Vertex(x:  1.0, y:  1.0, z: -1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 1.0 , v: 1.0)
        var V18 = Vertex(x: -1.0, y:  1.0, z: -1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0, u: 0.0 , v: 1.0)
        var V19 = Vertex(x: -1.0, y:  1.0, z:  1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0, u: 0.0 , v: 0.0)
        //Bottom
        var V20 = Vertex(x: -1.0, y: -1.0, z:  1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 0.0 , v: 1.0)
        var V21 = Vertex(x: -1.0, y: -1.0, z: -1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 0.0 , v: 0.0)
        var V22 = Vertex(x:  1.0, y: -1.0, z: -1.0, r: 0.1, g: 0.6, b: 0.4, a: 1.0, u: 1.0 , v: 0.0)
        var V23 = Vertex(x:  1.0, y: -1.0, z:  1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0, u: 1.0 , v: 1.0)
        
        var verticesArray:Array<Vertex> = [
            // Front
            V0, V1, V2,
            V2, V3, V0,
            // Back
            V4, V5, V6,
            V6, V7, V4,
            // Left
            V8, V9, V10,
            V10, V11, V8,
            // Right
            V12, V13, V14,
            V14, V15, V12,
            // Top
            V16, V17, V18,
            V18, V19, V16,
            // Bottom
            V20, V21, V22,
            V22, V23, V20
        ]
        
        var mTexture:METLTexture = METLTexture(resourceName: "bricks", ext: "jpeg")
        mTexture.finalize(baseEffect.device)
        
        super.init(name: "Cube", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, texture: mTexture.texture)
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
//        rotationZ += Float(M_PI/10) * Float(delta)
        rotationY += Float(M_PI/8) * Float(delta)
    }
}
