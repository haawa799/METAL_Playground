//
//  MetalViewProtocol.h
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/23/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

@protocol MetalViewProtocol <NSObject>

@optional

// is called on every screan redraw
-(void)update:(CFTimeInterval)delta;

@end