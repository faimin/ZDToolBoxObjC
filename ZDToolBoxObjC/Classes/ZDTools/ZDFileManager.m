//
//  ZDFileManager.m
//  ZDToolBoxObjC
//
//  Created by Zero on 15/7/11.
//  Copyright (c) 2015年 Zero.D.Saber. All rights reserved.
//

#import "ZDFileManager.h"
#include <dirent.h>
#include <sys/mount.h>
#include <sys/stat.h>

@implementation ZDFileManager

+ (NSString *)documentsPath {
	NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
	return documentsPath;
}

+ (NSString *)libraryPath {
	NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
	return libraryPath;
}

+ (NSString *)cachePath {
	NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
	return cachePath;
}

+ (NSString *)tempPath {
	return NSTemporaryDirectory();
}

+ (NSString *)homePath {
	return NSHomeDirectory();
}

+ (BOOL)isFileExistsAtPath:(NSString *)path {
	return [NSFileManager.defaultManager fileExistsAtPath:path];
}

+ (BOOL)isDirectoryAtPath:(NSString *)path {
	BOOL isDirectory;
	[NSFileManager.defaultManager fileExistsAtPath:path isDirectory:&isDirectory];
	return isDirectory;
}

+ (NSString *)uniquePathForPath:(NSString *)path {
    if (![NSFileManager.defaultManager fileExistsAtPath:path]) {
        return path;
    }
    
    NSString *directory = path.stringByDeletingLastPathComponent;
    NSString *file = path.lastPathComponent;
    NSString *base = file.stringByDeletingPathExtension;
    NSString *extension = file.pathExtension;
    int retries = 0;
    do {
        if (extension.length > 0) {
            path = [directory stringByAppendingPathComponent:[[base stringByAppendingFormat:@" (%i)", ++retries] stringByAppendingPathExtension:extension]];
        } else {
            path = [directory stringByAppendingPathComponent:[base stringByAppendingFormat:@" (%i)", ++retries]];
        }
    } while ([NSFileManager.defaultManager fileExistsAtPath:path]);
    return path;
}

//MARK:
+ (BOOL)mkdirAtPath:(NSString *)path {
	NSFileManager *fileManager = NSFileManager.defaultManager;
	BOOL isDir;
	BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];

	if (!(isDir && existed)) {
		NSError *__autoreleasing error;
		BOOL isOK = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		if (error) {
			NSLog(@"创建文件夹失败：%@", error);
		}
		return isOK;
	}
	NSLog(@"文件夹已存在at路径：%@", path);
	return NO;
}

+ (BOOL)deleteAtPath:(NSString *)path {
    NSFileManager *fileManager = NSFileManager.defaultManager;

	if (![fileManager fileExistsAtPath:path]) {
		NSLog(@"移除失败：文件不存在");
		return NO;
	}
	NSError *__autoreleasing error;
	BOOL isOK = [fileManager removeItemAtPath:path error:&error];
	if (error) {
		NSLog(@"移除失败：%@", error);
	}
	return isOK;
}

+ (BOOL)moveFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
	NSFileManager *fileManager = NSFileManager.defaultManager;
	if (![fileManager fileExistsAtPath:fromPath]) {
		NSLog(@"移动失败：文件不存在");
		return NO;
	}
    
	NSError *__autoreleasing error;
	BOOL isOK = [fileManager moveItemAtPath:fromPath toPath:toPath error:&error];
	if (error) {
		NSLog(@"移动失败：%@", error);
	}
	return isOK;
}

+ (BOOL)copyFromPath:(NSString *)fromPath toPath:(NSString *)toPath {
	NSFileManager *fileManager = NSFileManager.defaultManager;
	if (![fileManager fileExistsAtPath:fromPath]) {
		NSLog(@"复制失败：文件不存在");
		return NO;
	}
    
	NSError *__autoreleasing error;
	BOOL isOK = [fileManager copyItemAtPath:fromPath toPath:toPath error:&error];
	if (error) {
		NSLog(@"复制失败：%@", error);
	}
	return isOK;
}

+ (UInt64)fileSizeAtPath:(NSString *)path {
	NSError *__autoreleasing error;
	NSDictionary *attributes = [NSFileManager.defaultManager attributesOfItemAtPath:path error:&error];
	return attributes.fileSize;
}

+ (UInt64)folderSizeAtPath:(const char *)folderPath {
    DIR *dir = opendir(folderPath);
    if (dir == NULL) {
        return 0;
    }

    UInt64 folderSize = 0;
    struct dirent *child;
	while ( (child = readdir(dir) ) != NULL) {
		if ( (child->d_type == DT_DIR) && (
				( (child->d_name[0] == '.') && (child->d_name[1] == 0) ) ||
				( (child->d_name[0] == '.') && (child->d_name[1] == '.') && (child->d_name[2] == 0) )
				) ) {
			continue;
		}

		int folderPathLength = (int)strlen(folderPath);
		char childPath[1024];
		stpcpy(childPath, folderPath);

		if (folderPath[folderPathLength - 1] != '/') {
			childPath[folderPathLength] = '/';
			folderPathLength++;
		}
		stpcpy(childPath + folderPathLength, child->d_name);
		childPath[folderPathLength + child->d_namlen] = 0;

		if (child->d_type == DT_DIR) {
			folderSize += [self folderSizeAtPath:childPath];
			struct stat st;

			if (lstat(childPath, &st) == 0) {
				folderSize += st.st_size;
			}
		}
		else if ( (child->d_type == DT_REG) || (child->d_type == DT_LNK) ) {
			struct stat st;

			if (lstat(childPath, &st) == 0) {
				folderSize += st.st_size;
			}
		}
	}

	return folderSize;
}

+ (UInt64)directorySize:(NSString *)directoryPath recursive:(BOOL)recursive {
	UInt64 size = 0;
	BOOL isDir = NO;

	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	if ([fileManager fileExistsAtPath:directoryPath isDirectory:&isDir] && isDir) {
        NSError *__autoreleasing error;
        NSArray<NSString *> *contents = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
		for (NSString *item in contents) {
			NSString *fullItem = [directoryPath stringByAppendingPathComponent:item];

			if ([fileManager fileExistsAtPath:fullItem isDirectory:&isDir]) {
				if (isDir && recursive) {
					size += [self directorySize:fullItem recursive:YES];
				}
				else {
					size += [[[fileManager attributesOfItemAtPath:fullItem error:nil] objectForKey:NSFileSize] unsignedLongLongValue];
				}
			}
		}
	}
	return size;
}

+ (UInt64)totalDiskSpace {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	struct statfs tStats;
	//statfs([[paths lastObject] cString], &tStats);
    statfs([paths.lastObject UTF8String], &tStats);
	UInt64 totalSpace = (UInt64)(tStats.f_blocks * tStats.f_bsize);
	return totalSpace;
}

+ (SInt64)freeDiskSpace {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    SInt64 freespace = -1;
    
    struct statfs buf;
	if (statfs([paths.lastObject UTF8String], &buf) >= 0) {
		freespace = (UInt64)buf.f_bsize * buf.f_bfree;
	}
	return freespace;
}

// https://github.com/mpw/marcelweiher-libobjc2/blob/4612302061a3657bc95a387ddca8db58c6dd60c5/Foundation/platform_posix/NSFileManager_posix.m
+ (NSString *)pathContentOfSymbolicLinkAtPath:(NSString *)path {
    char linkbuf[MAXPATHLEN + 1];
    size_t length = readlink([path fileSystemRepresentation], linkbuf, MAXPATHLEN);
    if (length == -1) {
        return nil;
    }
    
    linkbuf[length] = 0;
    return [NSString stringWithCString:linkbuf encoding:NSUTF8StringEncoding];
}

+ (NSArray<NSString *> *)directoryContentsAtPath:(NSString *)path {
    if (!path) {
        return nil;
    }
    
    DIR *dirp = opendir(path.fileSystemRepresentation);
    if (dirp == NULL) {
        return nil;
    }
    
    NSMutableArray<NSString *> *result = [[NSMutableArray alloc] init];
    
    struct dirent *dire;
    while ((dire = readdir(dirp))) {
        if (strcmp(".", dire->d_name) == 0)
            continue;
        if (strcmp("..", dire->d_name) == 0)
            continue;
        NSString *str = [NSString stringWithCString:dire->d_name encoding:NSUTF8StringEncoding];
        if (str) {
            [result addObject:str];
        }
    }
    closedir(dirp);
    
    return result;
}

+ (NSString *)currentDirectoryPath {
    char path[MAXPATHLEN + 1];
    if (getcwd(path, sizeof(path)) != NULL) {
        return [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
    }
    return nil;
}
 
+ (void)clearUserDefaults {
#if 1
    NSString *appDomain = NSBundle.mainBundle.bundleIdentifier;
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
#else
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [userDefaults dictionaryRepresentation];
    for (id key in dict) {
        [userDefaults removeObjectForKey:key];
    }
    [userDefaults synchronize];
#endif
}

@end

///===================================================================

@implementation NSString (Path)

- (NSString *)zd_fileName {
	return self.lastPathComponent.stringByDeletingLastPathComponent;
}

- (NSString *)zd_fileFullName {
	return self.lastPathComponent;
}

- (NSString *)zd_joinString:(NSString *)string {
	return [self stringByAppendingString:string];
}

- (NSString *)zd_joinPath:(NSString *)path {
	return [self stringByAppendingPathComponent:path];
}

- (NSString *)zd_joinExtension:(NSString *)extension {
	return [self stringByAppendingPathExtension:extension];
}

+ (NSString *)zd_pathForTemporaryFile {
	CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
	CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
	NSString *tmpPath = [NSTemporaryDirectory() stringByAppendingPathComponent:(__bridge NSString *)newUniqueIdString];
	CFRelease(newUniqueId);
	CFRelease(newUniqueIdString);
	return tmpPath;
}

- (NSString *)zd_pathByIncrementingSequenceNumber {
	NSString *baseName = [self stringByDeletingPathExtension];
	NSString *extension = [self pathExtension];

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\(([0-9]+)\\)$" options:0 error:NULL];

    __block NSInteger sequenceNumber = 0;
	[regex enumerateMatchesInString:baseName options:0 range:NSMakeRange(0, [baseName length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
		NSRange range = [match rangeAtIndex:1]; // first capture group
		NSString *substring = [self substringWithRange:range];
		sequenceNumber = [substring integerValue];
		*stop = YES;
	}];

	NSString *nakedName = [baseName zd_pathByDeletingSequenceNumber];

	if ([extension isEqualToString:@""]) {
		return [nakedName stringByAppendingFormat:@"(%d)", (int)sequenceNumber + 1];
	}
	return [[nakedName stringByAppendingFormat:@"(%d)", (int)sequenceNumber + 1] stringByAppendingPathExtension:extension];
}

- (NSString *)zd_pathByDeletingSequenceNumber {
	NSString *baseName = [self stringByDeletingPathExtension];

	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\([0-9]+\\)$" options:0 error:NULL];
    __block NSRange range = NSMakeRange(NSNotFound, 0);
	[regex enumerateMatchesInString:baseName options:0 range:NSMakeRange(0, [baseName length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
		range = [match range];
		*stop = YES;
	}];

	if (range.location != NSNotFound) {
		return [self stringByReplacingCharactersInRange:range withString:@""];
	}

	return self;
}

@end
