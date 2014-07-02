//
//  METLTexture.swift
//  Textured Cube
//
//  Created by Andrew K. on 6/29/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

import UIKit
import Metal

class METLTexture: NSObject {
   
    var texture: MTLTexture?
    var target: MTLTextureType
    var width: UInt32
    var height: UInt32
    var depth: UInt32
    var format: MTLPixelFormat
    var hasAlpha: Bool
    var path: String
    
    init(name: String, extention: String)
    {
        var qPath = NSBundle.mainBundle().pathForResource(name, ofType: extention);
        
        path     = qPath
        width    = 0
        height   = 0
        depth    = 1
        format   = MTLPixelFormat.FormatRGBA8Unorm
        target   = MTLTextureType.Type2D
        texture  = nil
        hasAlpha = false
        
        super.init()
    }
    
    func finalizeTexture(device:MTLDevice) -> Bool
    {
        return finalizeTexture(device, flip: true)
    }
    
    func finalizeTexture(device: MTLDevice, flip: Bool) -> Bool
    {
        var pImage: UIImage? = UIImage(contentsOfFile: path)
        if pImage == nil
        {
            return false
        }
        
        var pColorSpace:CGColorSpaceRef  = CGColorSpaceCreateDeviceRGB()
        
        if pColorSpace == nil
        {
            pImage = nil
            return false
        } // if
        
        self.width  =  UInt32(CGImageGetWidth(pImage?.CGImage))
        self.height =  UInt32(CGImageGetHeight(pImage?.CGImage))
        
        var width = self.width
        var height   = self.height
        var rowBytes = width * 4
        
        var info:CGBitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.toRaw())
        
        var pContext:CGContextRef  = CGBitmapContextCreate(nil, UInt(width), UInt(height), 8, UInt(rowBytes), pColorSpace, info)
        
        

        CGColorSpaceRelease(pColorSpace)
        
        if pContext == nil
        {
            return false
        }
        
        var bounds = CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height));
        
        CGContextClearRect(pContext, bounds)
        
        // Vertical Reflect
        if(flip)
        {
            CGContextTranslateCTM(pContext, CGFloat(width), CGFloat(height));
            CGContextScaleCTM(pContext, -1.0, -1.0);
        } // if
        
        CGContextDrawImage(pContext, bounds, pImage!.CGImage);
        
        pImage = nil;
        
        var pTexDesc = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(MTLPixelFormat.FormatRGBA8Unorm, width: Int(width), height: Int(height), mipmapped: false)
        self.target = pTexDesc.textureType
        self.texture = device.newTextureWithDescriptor(pTexDesc)
        
        pTexDesc = nil;
        
        if self.texture == nil
        {
            CGContextRelease(pContext)
            return false
        }
        
        var pPixels: COpaquePointer = CGBitmapContextGetData(pContext);
        self.texture?.replaceRegion(MTLTextureRegionMake2D(0, 0, Int(width), Int(height)), mipmapLevel: 0, withBytes: pPixels, bytesPerRow: Int(rowBytes))
        
            
        CGContextRelease(pContext)
        
        return true
    }
    
}
