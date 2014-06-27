//
//  Matrix4.m
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "Matrix4.h"

@implementation Matrix4

+ (float)degreesToRad:(float)degrees
{
    return GLKMathDegreesToRadians(degrees);
}

+ (Matrix4 *)makePerspectiveViewAngle:(float)angleRad
                          aspectRatio:(float)aspect
                                nearZ:(float)nearZ
                                 farZ:(float)farZ
{
    Matrix4 *matrix = [[Matrix4 alloc] init];
    matrix->glkMatrix = GLKMatrix4MakePerspective(angleRad, aspect, nearZ, farZ);
    return matrix;
}

-(instancetype)init
{
    self = [super init];
    if(self != nil)
    {        
        glkMatrix = GLKMatrix4Identity;
    }
    return self;
}

-(void)transpose
{
    glkMatrix = GLKMatrix4Transpose(glkMatrix);
}


- (void)multiplyLeft:(Matrix4 *)matrix
{
    glkMatrix = GLKMatrix4Multiply(matrix->glkMatrix, glkMatrix);
}

- (void)rotateAroundX:(float)xAngleRad y:(float)yAngleRad z:(float)zAngleRad
{
    glkMatrix = GLKMatrix4Rotate(glkMatrix, xAngleRad, 1, 0, 0);
    glkMatrix = GLKMatrix4Rotate(glkMatrix, yAngleRad, 0, 1, 0);
    glkMatrix = GLKMatrix4Rotate(glkMatrix, zAngleRad, 0, 0, 1);
}



-(void)translate:(float)x y:(float)y z:(float)z
{
    glkMatrix = GLKMatrix4Translate(glkMatrix, x, y, z);
}

-(void)scale:(float)x y:(float)y z:(float)z
{
    glkMatrix = GLKMatrix4Scale(glkMatrix, x, y, z);
}


@end
