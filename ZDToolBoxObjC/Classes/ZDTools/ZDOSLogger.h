//
//  ZDOSLogger.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2020/8/7.
//
//  把日志同步到Mac控制台(封装的os_log)

#import <Foundation/Foundation.h>
#import <os/log.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(10_0)
@interface ZDOSLogger : NSObject

@property (nonatomic, strong, readonly) os_log_t osLog;

+ (ZDOSLogger *)shareInstance;

- (instancetype)initWithSubsystem:(NSString *_Nullable)subsystem
                         category:(NSString *_Nullable)category;

+ (void)logWithType:(os_log_type_t)type message:(id)msg;

@end

NS_ASSUME_NONNULL_END


/**
 i.e.
 ZDOSLog(OS_LOG_TYPE_DEBUG, "message： %{public}@", dic);
 */
#if !RELEASE

#ifndef ZDOSLog
#define ZDOSLog(type, format, ...) \
switch (type) { \
    case OS_LOG_TYPE_INFO:  \
        os_log_info([ZDOSLogger shareInstance].osLog, "%s, [Line: %d],\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);   \
        break;  \
    case OS_LOG_TYPE_DEBUG: \
        os_log_debug([ZDOSLogger shareInstance].osLog, "%s, [Line: %d],\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);  \
        break;  \
    case OS_LOG_TYPE_ERROR: \
        os_log_error([ZDOSLogger shareInstance].osLog, "%s, [Line: %d],\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);  \
        break;  \
    case OS_LOG_TYPE_FAULT: \
        os_log_fault([ZDOSLogger shareInstance].osLog, "%s, [Line: %d],\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);  \
        break;  \
    default:    \
        os_log([ZDOSLogger shareInstance].osLog, "%s, [Line: %d],\n" format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);    \
        break;  \
};
#endif

#else

#define ZDOSLog(type, format, ...)

#endif
