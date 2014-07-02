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
        var verticesArray:Array<Vertex> = []
        
        let path = NSBundle.mainBundle().pathForResource("cube", ofType: "txt")
        var possibleContent = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: nil)
        
        if let content = possibleContent {
            var array = content.componentsSeparatedByString("\n")
            for line in array{
                var vertex = Vertex(text: line)
                verticesArray.append(vertex)
            }
        }
        
        super.init(name: "Cube", baseEffect: baseEffect, vertices: verticesArray, vertexCount: verticesArray.count, textureName: "bricks.jpeg")
    }
    
    override func updateWithDelta(delta: CFTimeInterval)
    {
        super.updateWithDelta(delta)
        
//        rotationZ += Float(M_PI/10) * Float(delta)
        rotationY += Float(M_PI/8) * Float(delta)
    }
}
