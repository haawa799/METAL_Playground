//
//  MetalView.m
//  MetalTryOut-Objc
//
//  Created by Andrew K. on 6/20/14.
//  Copyright (c) 2014 Andrew Kharchyshyn. All rights reserved.
//

#import "MetalView.h"
#import <QuartzCore/CAMetalLayer.h>


@implementation MetalView{
    CADisplayLink *_displayLink;
    CFTimeInterval _lastFrameTimestamp;
    UILabel *_fpsLabel;
}

#pragma mark - Public API

- (void)setFPSLabelHidden:(BOOL)hidden
{
    _fpsLabel.hidden = hidden;
}

- (void)pause
{
    _displayLink.paused = YES;
}

- (void)resume
{
    _displayLink.paused = NO;
}

#pragma mark - UIView

+ (id)layerClass
{
    return [CAMetalLayer class];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self != nil){
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil)
    {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_fpsLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
    NSLayoutConstraint *botConstraint = [NSLayoutConstraint constraintWithItem:_fpsLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:_fpsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:25.0];
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:_fpsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1.0 constant:80.0];
    
    [self addConstraints:@[rightConstraint,botConstraint,heightConstraint,widthConstraint]];
}

- (void)dealloc
{
    [self tearDown];
}

#pragma  mark - private

- (void)setup
{
    _fpsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fpsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_fpsLabel];
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawCall:)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)tearDown
{
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)drawCall:(CADisplayLink *)displayLink
{
    if (!_lastFrameTimestamp)
        _lastFrameTimestamp = displayLink.timestamp;
    
    CFTimeInterval elapsed = (displayLink.timestamp - _lastFrameTimestamp);
    
    if (_fpsLabel.hidden == NO){
        CGFloat fps = 1.0 / elapsed;
        _fpsLabel.text = [NSString stringWithFormat:@"fps: %0.1f",fps];
    }
    _lastFrameTimestamp = displayLink.timestamp;
    
    if([self.metalViewDelegate respondsToSelector:@selector(update:)]){
        [self.metalViewDelegate update:elapsed];
    }
}

@end
