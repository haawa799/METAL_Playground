//
//  Triangle.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit


@objc class Triangle: Model
{
    init(baseEffect: BaseEffect)
    {
        var A = Vertex(x: -1.0, y: -1.0, z: 0.0, w: 1.0, r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        var B = Vertex(x: 1.0, y: -1.0, z: 0.0, w: 1.0, r: 0.0, g: 1.0, b: 0.0, a: 1.0)
        var C = Vertex(x: 0.0, y: 0.0, z: 0.0, w: 1.0, r: 0.0, g: 0.0, b: 1.0, a: 1.0)
        
        var verticesArray:Array<Vertex> = [A,B,C]
        
        super.init(name: "Triangle", baseEffect: baseEffect, vertices: verticesArray, vertexCount: 3)
    }
}
