//
//  CAAnimation+ZDUtility.h
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/26.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CAAStartBlock)(CAAnimation *);
typedef void(^CAAStopBlock)(CAAnimation *, BOOL);

@interface CAAnimation (ZDUtility)

- (void)zd_animationDidStart:(CAAStartBlock)block;

- (void)zd_animationDidStop:(CAAStopBlock)block;

@end

NS_ASSUME_NONNULL_END
