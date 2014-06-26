//
//  Matrix4x4.swift
//  Triangle
//
//  Created by Andrew K. on 6/25/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit

@objc class Matrix4x4: NSObject {
    let rows: Int = 4
    let columns: Int = 4
    var grid: Float[]
    
    func description() -> String {
        return "\(grid)"
    }
    
    init() {
        grid = Array(count: rows * columns, repeatedValue: 0.0)
        super.init()
        setIdenity()
        println(grid)
    }
    
    func setIdenity()
    {
        grid = Array(count: rows * columns, repeatedValue: 0.0)
        grid[0] = 1.0
        grid[5] = 1.0
        grid[10] = 1.0
        grid[15] = 1.0
    }
}
