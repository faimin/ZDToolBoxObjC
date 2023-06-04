//
//  ZDPermissionManager.m
//  Pods
//
//  Created by Zero.D.Saber on 2017/7/31.
//
//

#import "ZDPermissionHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

@implementation ZDPermissionHandler

/// 相机权限
+ (BOOL)zd_isCapturePermissionGranted {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block BOOL isGranted = YES;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            isGranted = granted;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return isGranted;
    }
    else {
        return YES;
    }
}

/// 相册权限
+ (BOOL)zd_isAssetsLibraryPermissionGranted {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
        return NO;
    }
    else if (authStatus == PHAuthorizationStatusNotDetermined) {
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block BOOL isGranted = YES;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            switch (status) {
                case PHAuthorizationStatusRestricted:
                case PHAuthorizationStatusDenied:
                    isGranted = NO;
                    break;
                case PHAuthorizationStatusAuthorized:
                    isGranted = YES;
                    break;
                default:
                    break;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        return isGranted;
    }
    
    return YES;
}

@end







