//
//  BaseEffectHelper.m
//  Triangle
//
//  Created by Andrew K. on 6/24/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "BaseEffectSfiftFixer.h"

@implementation BaseEffectSfiftFixer

+ (void)setup:(MTLRenderPipelineDescriptor *)desc
{
    desc.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
}

@end
