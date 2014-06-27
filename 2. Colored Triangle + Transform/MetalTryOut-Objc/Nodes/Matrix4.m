//
//  Matrix4.m
//  Triangle
//
//  Created by Andrew K. on 6/27/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "Matrix4.h"

@implementation Matrix4

-(instancetype)init
{
    self = [super init];
    if(self != nil)
    {
        mat[0]=1.0f;
        mat[5]=1.0f;
        mat[10]=1.0f;
        mat[15]=1.0f;
    }
    return self;
}

-(void)transpose
{
    float tmp[16];
    int i,j;
    for(i=0;i<4;i++) {
        for(j=0;j<4;j++) {
            tmp[4*i+j] = mat[i+4*j];
        }
    }
    for(i=0;i<16;i++)
        mat[i] = tmp[i];
}

-(void)multiplyMatrix:(Matrix4 *)m
{
    float tmp[4];
    for (int j=0; j<4; j++) {
        tmp[0] = mat[j];
        tmp[1] = mat[4+j];
        tmp[2] = mat[8+j];
        tmp[3] = mat[12+j];
        for (int i=0; i<4; i++)
        {
            mat[4*i+j] = m->mat[4*i ]*tmp[0] + m->mat[4*i+1]*tmp[1] + m->mat[4*i+2]*tmp[2] + m->mat[4*i+3]*tmp[3];
        }
    }
}

-(void)rotateAroundX:(float)angleRad
{
    Matrix4 *m = [[Matrix4 alloc] init];                    // create identity matrix
    
    m->mat[ 0] = 1.0;
    m->mat[ 5] = cosf(angleRad);
    m->mat[10] = m->mat[5];
    m->mat[ 6] = sinf(angleRad);
    m->mat[ 9] = -m->mat[6];
    
    [self multiplyMatrix:m];
}

-(void)rotateAroundY:(float)angleRad
{
    Matrix4 *m = [[Matrix4 alloc] init];                    // create identity matrix
    
    m->mat[ 0] = cosf(angleRad);
    m->mat[ 5] = 1.0;
    m->mat[10] = m->mat[0];
    m->mat[ 2] = -sinf(angleRad);
    m->mat[ 8] = -m->mat[2];
    
    [self multiplyMatrix:m];
}

-(void)rotateAroundZ:(float)angleRad
{
    Matrix4 *m = [[Matrix4 alloc] init];                    // create identity matrix
    
    m->mat[ 0] = cosf(angleRad);
    m->mat[ 5] = m->mat[0];
    m->mat[10] =  1.0;
    m->mat[ 1] = sinf(angleRad);
    m->mat[ 4] = -m->mat[1];
    
    [self multiplyMatrix:m];
}

-(void)translate:(float)x y:(float)y z:(float)z
{
    Matrix4 *m = [[Matrix4 alloc] init]; // create identity matrix
    
    m->mat[12] = x;
    m->mat[13] = y;
    m->mat[14] = z;
    
    [self multiplyMatrix:m];
}

-(void)scale:(float)x y:(float)y z:(float)z
{
    Matrix4 *m = [[Matrix4 alloc] init]; // create identity matrix
    
    m->mat[0] = x;
    m->mat[5] = y;
    m->mat[10] = z;
    
    [self multiplyMatrix:m];
}

@end
