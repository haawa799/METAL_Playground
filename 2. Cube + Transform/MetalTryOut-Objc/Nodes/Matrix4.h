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

@interface Matrix4 : NSObject
{
    @public
    GLKMatrix4 glkMatrix;
}

//matrix->glkMatrix = GLKMatrix4MakePerspective(<#float fovyRadians#>, <#float aspect#>, <#float nearZ#>, <#float farZ#>)

+ (float)degreesToRad:(float)degrees;

+ (Matrix4 *)makePerspectiveViewAngle:(float)angleRad
                          aspectRatio:(float)aspect
                                nearZ:(float)nearZ
                                 farZ:(float)farZ;

- (void)transpose;

- (void)normalize;

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
