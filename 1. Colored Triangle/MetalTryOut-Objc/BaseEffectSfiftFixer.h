//
//  BaseEffectHelper.h
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface BaseEffectSfiftFixer : NSObject

+ (void)setup:(MTLRenderPipelineDescriptor *)desc;

@end
