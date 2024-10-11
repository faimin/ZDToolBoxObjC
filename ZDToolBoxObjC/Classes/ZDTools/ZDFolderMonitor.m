//
//  ZDFolderMonitor.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/12.
//

#import "ZDFolderMonitor.h"

@interface ZDFolderMonitor ()
@property (nonatomic, copy) NSString *dirPath;
@property (nonatomic, copy) void(^callback)(ZDFileChangeType);
@property (nonatomic, strong) dispatch_source_t source;
@end

@implementation ZDFolderMonitor

- (void)dealloc {
    [self stopMonitor];
}

- (instancetype)initWithDirectoryPath:(NSString *)path onChange:(void(^)(ZDFileChangeType))callback {
    if (self = [super init]) {
        _dirPath = path;
        _callback = callback;
    }
    return self;
}

- (void)startMonitor {
    NSURL *dirUrl = [NSURL fileURLWithPath:_dirPath];
    const int fd = open(dirUrl.path.fileSystemRepresentation, O_EVTONLY);
    if (fd < 0) {
        NSLog(@"Unable to open the path = %@", dirUrl.path);
        return;
    }
    
    //https://github.com/objcio/articles/blob/ce8898e4254835237a13b30611060faa88700d19/2013-07-07-low-level-concurrency-apis.md?plain=1#L469
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd, DISPATCH_VNODE_WRITE | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_DELETE, DISPATCH_TARGET_QUEUE_DEFAULT);
    __weak typeof(self) weakTarget = self;
    dispatch_source_set_event_handler(_source, ^{
        __strong typeof(weakTarget) self = weakTarget;
        if (!self.callback) {
            return;
        }
        unsigned long const type = dispatch_source_get_data(self.source);
        switch (type) {
            case DISPATCH_VNODE_WRITE: {
                NSLog(@"目录内容改变!!!");
                self.callback(ZDFileChangeType_Write);
                break;
            }
            case DISPATCH_VNODE_RENAME: {
                NSLog(@"目录被重命名!!!");
                self.callback(ZDFileChangeType_Rename);
                break;
            }
            case DISPATCH_VNODE_DELETE: {
                NSLog(@"目录被删除");
                self.callback(ZDFileChangeType_Delete);
                [self stopMonitor];
                break;
            }
            default:
                break;
        }
    });
    dispatch_source_set_cancel_handler(_source, ^{
        close(fd);
    });
    dispatch_resume(_source);
}

- (void)stopMonitor {
    if (!_source) {
        return;
    }
    dispatch_source_cancel(_source);
    _source = nil;
}

@end
