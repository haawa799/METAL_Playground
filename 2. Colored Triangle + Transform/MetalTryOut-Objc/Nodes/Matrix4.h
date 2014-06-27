//
//  Matrix4.h
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Matrix4 : NSObject
{
    @public
    float mat[16];
}

-(void)transpose;

-(void)multiplyMatrix:(Matrix4 *)m;

-(void)rotateAroundX:(float)angleRad;

-(void)rotateAroundY:(float)angleRad;

-(void)rotateAroundZ:(float)angleRad;

-(void)translate:(float)x y:(float)y z:(float)z;

-(void)scale:(float)x y:(float)y z:(float)z;

@end
