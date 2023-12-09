//
//  NSMutableArray+ZDUtility.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2017/7/4.
//
//

#import "NSMutableArray+ZDUtility.h"

@implementation NSMutableArray (ZDUtility)

+ (instancetype)zd_mutableArrayUsingWeakReferences {
    return [self zd_mutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (instancetype)zd_mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity {
    CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
    // Cast of C pointer type 'CFMutableArrayRef' (aka 'struct __CFArray *') to Objective-C pointer type 'id' requires a bridged cast
    return (NSMutableArray *)CFBridgingRelease(CFArrayCreateMutable(0, capacity, &callbacks));
}

@end

