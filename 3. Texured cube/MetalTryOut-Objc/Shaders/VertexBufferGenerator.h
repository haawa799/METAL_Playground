//
//  VertexBufferGenerator.h
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>


@interface VertexBufferGenerator : NSObject

+ (id <MTLBuffer>)generateBufferVertices:(NSArray *)vertices
                             vertexCount:(NSNumber *)vertexCount
                                  device:(id <MTLDevice>)device;


@end
