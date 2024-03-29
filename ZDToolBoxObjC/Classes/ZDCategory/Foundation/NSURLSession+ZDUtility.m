//
//  NSURLSession+ZDUtility.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2017/7/13.
//
//

#import "NSURLSession+ZDUtility.h"

@implementation NSURLSession (ZDUtility)

- (NSData *)zd_syncTaskWithRequest:(NSURLRequest *)request
                             error:(NSError * __autoreleasing *)error {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block NSData *responseData = nil;
    NSURLSessionTask *task = [self dataTaskWithRequest:request completionHandler:^(NSData * _Nullable resultData, NSURLResponse * _Nullable response, NSError * _Nullable resultError) {
        responseData = resultData;
        if (error) *error = resultError;
        
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return responseData;
}

@end
