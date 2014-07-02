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
    var x,y,z,u,v,nX,nY,nZ: Float
    
    
    init(x:Float, y:Float, z:Float, u:Float ,v:Float ,nX:Float ,nY:Float ,nZ:Float)
    {
        self.x = x
        self.y = y
        self.z = z
        
        self.u = u
        self.v = v
        
        self.nX = nX
        self.nY = nY
        self.nZ = nZ
        
        super.init()
    }
    
    init(text: String)
    {
        var list = text.componentsSeparatedByString(" ")
        
        var counter = 0
        
        self.x = list[counter++].bridgeToObjectiveC().floatValue
        self.y = list[counter++].bridgeToObjectiveC().floatValue
        self.z = list[counter++].bridgeToObjectiveC().floatValue
        
        self.u = list[counter++].bridgeToObjectiveC().floatValue
        self.v = list[counter++].bridgeToObjectiveC().floatValue
        
        self.nX = list[counter++].bridgeToObjectiveC().floatValue
        self.nY = list[counter++].bridgeToObjectiveC().floatValue
        self.nZ = list[counter++].bridgeToObjectiveC().floatValue
        
        super.init()
    }
    
}
