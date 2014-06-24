//
//  MetalView.h
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/20/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetalViewProtocol.h"


@interface MetalView : UIView

@property(nonatomic,weak) id <MetalViewProtocol> metalViewDelegate;

- (void)setFPSLabelHidden:(BOOL)hidden;

- (void)pause;
- (void)resume;

@end
