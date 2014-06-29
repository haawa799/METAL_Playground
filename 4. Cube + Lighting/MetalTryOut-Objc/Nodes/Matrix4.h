//
//  Matrix4.h
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GLKit/GLKMath.h>

// Wraper around GLKMath's GLKMatrix4, becouse we can't use it directly from Swift code

@interface Matrix4 : NSObject
{
    @public
    GLKMatrix4 glkMatrix;
}

+ (float)degreesToRad:(float)degrees;

+ (Matrix4 *)makePerspectiveViewAngle:(float)angleRad
                          aspectRatio:(float)aspect
                                nearZ:(float)nearZ
                                 farZ:(float)farZ;

- (void)transpose;

- (void)multiplyLeft:(Matrix4 *)matrix;

- (void)rotateAroundX:(float)xAngleRad
                    y:(float)yAngleRad
                    z:(float)zAngleRad;

- (void)translate:(float)x
                y:(float)y
                z:(float)z;

- (void)scale:(float)x
            y:(float)y
            z:(float)z;

@end
