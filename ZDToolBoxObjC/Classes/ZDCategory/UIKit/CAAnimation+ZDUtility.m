//
//  CAAnimation+ZDUtility.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/26.
//

#import "CAAnimation+ZDUtility.h"

@interface _ZDAnimationDelegate : NSObject <CAAnimationDelegate>
@property (nonatomic, copy) CAAStartBlock startBlock;
@property (nonatomic, copy) CAAStopBlock stopBlock;
@end

@implementation CAAnimation (ZDUtility)

- (void)zd_animationDidStart:(CAAStartBlock)block {
    _ZDAnimationDelegate *delegate = self.delegate;
    if (delegate && [delegate isKindOfClass:_ZDAnimationDelegate.class]) {
        delegate.startBlock = block;
    } else {
        delegate = [[_ZDAnimationDelegate alloc] init];
        delegate.startBlock = block;
        self.delegate = delegate;
    }
}

- (void)zd_animationDidStop:(CAAStopBlock)block {
    _ZDAnimationDelegate *delegate = self.delegate;
    if (delegate && [delegate isKindOfClass:_ZDAnimationDelegate.class]) {
        delegate.stopBlock = block;
    } else {
        delegate = [[_ZDAnimationDelegate alloc] init];
        delegate.stopBlock = block;
        self.delegate = delegate;
    }
}

@end

@implementation _ZDAnimationDelegate

#pragma mark - CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    !self.startBlock ?: self.startBlock(anim);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    !self.stopBlock ?: self.stopBlock(anim, flag);
}

@end
