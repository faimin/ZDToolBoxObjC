//
//  ZDFileWatcher.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/10/12.
//

#import "ZDFileWatcher.h"

@interface ZDFileWatcher ()
@property (nonatomic, copy) NSString *dirPath;
@property (nonatomic, copy) void(^onChangeBlock)(ZDFileChangeType);
@property (nonatomic, strong) dispatch_source_t source;
@property (nonatomic, assign) BOOL keepWatch;
@end

@implementation ZDFileWatcher

- (void)dealloc {
    [self stopWatch];
}

- (instancetype)initWithPath:(NSString *)path onChange:(void(^)(ZDFileChangeType))callback {
    if (self = [super init]) {
        _dirPath = path;
        _onChangeBlock = callback;
    }
    return self;
}

- (void)startWatch {
    NSURL *dirUrl = [NSURL fileURLWithPath:_dirPath];
    const int fd = open(dirUrl.path.fileSystemRepresentation, O_EVTONLY);
    if (fd < 0) {
        NSLog(@"Unable to open the path = %@", dirUrl.path);
        return;
    }
    
    //https://github.com/objcio/articles/blob/ce8898e4254835237a13b30611060faa88700d19/2013-07-07-low-level-concurrency-apis.md?plain=1#L469
    dispatch_queue_t watchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fd, DISPATCH_VNODE_WRITE | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_DELETE, watchQueue);
    __weak typeof(self) weakTarget = self;
    dispatch_source_set_event_handler(_source, ^{
        __strong typeof(weakTarget) self = weakTarget;
        unsigned long const type = dispatch_source_get_data(self.source);
        [self _handleFileChangeEvent:type];
    });
    dispatch_source_set_cancel_handler(_source, ^{
        __strong typeof(weakTarget) self = weakTarget;
        close(fd);
        
        self.source = nil;
        
        if (self.keepWatch) {
            self.keepWatch = NO;
            [self startWatch];
        }
    });
    dispatch_resume(_source);
}

- (void)stopWatch {
    if (!_source) {
        return;
    }
    dispatch_source_cancel(_source);
}

#pragma mark - Private

- (void)_reWatch {
    if (!_source) {
        return;
    }
    self.keepWatch = YES;
    dispatch_source_cancel(_source);
}

#pragma mark - Action

- (void)_handleFileChangeEvent:(unsigned long)eventType {
    BOOL reWatchFileIfNeed = NO;
    NSMutableSet<NSNumber *> *eventSet = [[NSMutableSet alloc] initWithCapacity:3];
    
    if (eventType & DISPATCH_VNODE_WRITE) {
        [eventSet addObject:@(DISPATCH_VNODE_WRITE)];
    }
    if (eventType & DISPATCH_VNODE_RENAME) {
        [eventSet addObject:@(DISPATCH_VNODE_RENAME)];
        reWatchFileIfNeed = YES;
    }
    if (eventType & DISPATCH_VNODE_DELETE) {
        [eventSet addObject:@(DISPATCH_VNODE_DELETE)];
        reWatchFileIfNeed = YES;
    }
    
    if (self.onChangeBlock) {
        for (NSNumber *item in eventSet) {
            self.onChangeBlock(item.unsignedIntegerValue);
        }
    }
    
    if (reWatchFileIfNeed) {
        [self _reWatch];
    }
}

@end
