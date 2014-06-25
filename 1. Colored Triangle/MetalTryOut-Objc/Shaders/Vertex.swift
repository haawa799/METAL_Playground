//
//  Vertex.swift
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc class Vertex: NSObject
{
    var x,y,z,w,r,g,b,a: Float
    
    init(x:Float, y:Float, z:Float, w:Float, r:Float, g:Float, b:Float, a:Float)
    {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        
        super.init()
    }
}
