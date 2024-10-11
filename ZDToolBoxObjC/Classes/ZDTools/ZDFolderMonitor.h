//
//  ZDFolderMonitor.h
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZDFileChangeType) {
    ZDFileChangeType_Write,
    ZDFileChangeType_Rename,
    ZDFileChangeType_Delete,
};

@interface ZDFolderMonitor : NSObject

- (instancetype)initWithDirectoryPath:(NSString *)path onChange:(void(^_Nullable)(ZDFileChangeType))callback;

- (void)startMonitor;
- (void)stopMonitor;

@end

NS_ASSUME_NONNULL_END
