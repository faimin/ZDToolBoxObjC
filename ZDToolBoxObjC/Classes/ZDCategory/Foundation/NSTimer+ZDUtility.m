//
//  NSTimer+ZDUtility.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2017/4/13.
//
//

#import "NSTimer+ZDUtility.h"

@implementation NSTimer (ZDUtility)

#pragma mark - Public Method

+ (NSTimer *)zd_scheduledTimerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(zd_executeTimerBlock:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)zd_timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(zd_executeTimerBlock:) userInfo:[block copy] repeats:repeats];
}

#pragma mark - Private Method

+ (void)zd_executeTimerBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void(^timerBlock)(NSTimer *) = (void(^)(NSTimer *))[timer userInfo];
        timerBlock(timer);
    }
}

#pragma mark - another no cycle ref method

+ (instancetype)zd_fireSecondsFromNow:(NSTimeInterval)delay block:(dispatch_block_t)block {
    if (@available(iOS 10, *)) {
        return [self scheduledTimerWithTimeInterval:delay repeats:NO block:^(NSTimer * _Nonnull timer) {
            !block ?: block();
        }];
    }
    else {
        return [self scheduledTimerWithTimeInterval:delay target:block selector:@selector(invoke) userInfo:nil repeats:NO];
    }
}

@end
