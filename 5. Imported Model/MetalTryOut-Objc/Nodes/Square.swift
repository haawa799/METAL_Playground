//
//  Square.swift
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc class Square: Node {
    
    init(baseEffect: BaseEffect)
    {
        var V0  = Vertex(x:  1.0, y: -1.0, z:  1.0, u: 1.0 , v: 0.0 , nX: 0.0 , nY: 0.0 , nZ: 0.0)
        var V1  = Vertex(x:  1.0, y:  1.0, z:  1.0, u: 1.0 , v: 1.0 , nX: 0.0 , nY: 0.0 , nZ: 0.0)
        var V2  = Vertex(x: -1.0, y:  1.0, z:  1.0, u: 0.0 , v: 1.0 , nX: 0.0 , nY: 0.0 , nZ: 0.0)
        var V3  = Vertex(x: -1.0, y: -1.0, z:  1.0, u: 0.0 , v: 0.0 , nX: 0.0 , nY: 0.0 , nZ: 0.0)
        
        var verticesArray:Array<Vertex> = [V0, V1, V2, V2, V3, V0]
        
        var mTexture:METLTexture = METLTexture(resourceName: "bricks", ext: "jpeg")
        mTexture.finalize(baseEffect.device)
        
        super.init(name: "Square", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "bricks.jpeg")
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
        var secsPerMove: Float = 2.0
        positionX = sinf( Float(time) * 2.0 * Float(M_PI) / secsPerMove)
    }
}
