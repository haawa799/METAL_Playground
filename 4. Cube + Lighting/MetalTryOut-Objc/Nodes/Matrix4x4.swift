//
//  Matrix4x4.swift
//  Triangle
//
//  Created by Andrew K. on 6/25/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

@objc class Matrix4x4 {
    
    let rows: Int = 4
    let columns: Int = 4
    var grid: [Float]
    
    init() {
        grid = Array(count: rows * columns, repeatedValue: 0.0)
        grid[0] = 1.0
        grid[5] = 1.0
        grid[10] = 1.0
        grid[15] = 1.0
    }
    
    func transpose()
    {
        var tmp: [Float] = Array(count: rows * columns, repeatedValue: 0.0)
        var i,j : Int
        for i = 0; i < 4; i++
        {
            for j = 0; j < 4; j++
            {
                tmp[4 * i + j] = grid[i + 4 * j]
            }
        }
        for var i = 0; i < 16; i++
        {
            grid[i] = tmp[i]
        }
    }
    
    func multiplyMatrix(matrix: Matrix4x4)
    {
        var tmp: [Float] = Array(count: columns, repeatedValue: 0.0)
        for var j = 0; j < 4; j++
        {
            tmp[0] = grid[j]
            tmp[1] = grid[4+j]
            tmp[2] = grid[8+j];
            tmp[3] = grid[12+j];
            for var i = 0; i < 4; i++
            {
                var value = matrix.grid[4*i  ]*tmp[0]
                value = value + matrix.grid[4*i+1]*tmp[1]
                value = value + matrix.grid[4*i+2]*tmp[2]
                value = value + matrix.grid[4*i+3]*tmp[3]
                
                grid[4*i+j] = value
            }
        }
    }

    func rotateAroundX(angleRad: Float)
    {
        var m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = 1.0
        m.grid[ 5] = cosf(angleRad)
        m.grid[10] = m.grid[5]
        m.grid[ 6] = sinf(angleRad)
        m.grid[ 9] = -m.grid[6]
        
        multiplyMatrix(m)
    }
    
    func rotateAroundY(angleRad: Float)
    {
        var m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = cosf(angleRad)
        m.grid[ 5] = 1.0
        m.grid[10] = m.grid[0]
        m.grid[ 2] = -sinf(angleRad)
        m.grid[ 8] = -m.grid[2]
        
        multiplyMatrix(m)
    }
    
    func rotateAroundZ(angleRad: Float)
    {
        var m: Matrix4x4 = Matrix4x4()
        
        m.grid[ 0] = cosf(angleRad)
        m.grid[ 5] = m.grid[0]
        m.grid[10] =  1.0
        m.grid[ 1] = sinf(angleRad)
        m.grid[ 4] = -m.grid[1]
        
        multiplyMatrix(m)
    }
    
    func translate(x:Float, y:Float, z:Float)
    {
        var m: Matrix4x4 = Matrix4x4()            // create identity matrix
        m.grid[12] = x
        m.grid[13] = y
        m.grid[14] = z
        
        multiplyMatrix(m)
    }
    
    func scale(x:Float, y:Float, z:Float)
    {
        var m: Matrix4x4 = Matrix4x4()            // create identity matrix
        m.grid[12] = x
        m.grid[13] = y
        m.grid[14] = z
        
        multiplyMatrix(m)
    }
}
