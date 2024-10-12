//
//  ZDFileWatcher.h
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZDFileChangeType) {
    ZDFileChangeType_Write = DISPATCH_VNODE_WRITE,
    ZDFileChangeType_Rename = DISPATCH_VNODE_RENAME,
    ZDFileChangeType_Delete = DISPATCH_VNODE_DELETE,
};

@interface ZDFileWatcher : NSObject

- (instancetype)initWithPath:(NSString *)path onChange:(void(^_Nullable)(ZDFileChangeType))callback;

- (void)startWatch;
- (void)stopWatch;

@end

NS_ASSUME_NONNULL_END
