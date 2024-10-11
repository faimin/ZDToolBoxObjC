//
//  ZDFileManager.h
//  ZDToolBoxObjC
//
//  Created by Zero on 15/7/11.
//  Copyright (c) 2015年 Zero.D.Saber. All rights reserved.
//
//  http://nshipster.cn/nsfilemanager/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDFileManager : NSObject

//MARK:Path
+ (NSString *)documentsPath;

+ (NSString *)libraryPath;

+ (NSString *)cachePath;

+ (NSString *)tempPath;

+ (NSString *)homePath;

+ (BOOL)isFileExistsAtPath:(NSString *)path;

+ (BOOL)isDirectoryAtPath:(NSString *)path;

// 如果本地已有重名文件，文件名自动+1
+ (NSString *)uniquePathForPath:(NSString *)path;

//MARK: creat、move、remove、sizeCount
+ (BOOL)mkdirAtPath:(NSString *)path;

+ (BOOL)deleteAtPath:(NSString *)path;

+ (BOOL)moveFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath;

+ (BOOL)copyFromPath:(NSString *)fromPath
              toPath:(NSString *)toPath;

+ (UInt64)fileSizeAtPath:(NSString *)path;

+ (UInt64)folderSizeAtPath:(const char*)folderPath;

+ (UInt64)directorySize:(NSString *)directoryPath
              recursive:(BOOL)recursive;

+ (UInt64)totalDiskSpace;

+ (SInt64)freeDiskSpace;

+ (nullable NSString *)pathContentOfSymbolicLinkAtPath:(NSString *)path;

+ (NSArray<NSString *> *)directoryContentsAtPath:(NSString *)path;

+ (NSString *)currentDirectoryPath;

/// 清空NSUserDefaults中的全部数据
+ (void)clearUserDefaults;

@end


///==================================================================

@interface NSString (Path)

- (NSString *)zd_fileName;

- (NSString *)zd_fileFullName;

- (NSString *)zd_joinString:(NSString *)string;

- (NSString *)zd_joinPath:(NSString *)path;

- (NSString *)zd_joinExtension:(NSString *)extension;

/** Creates a unique filename that can be used for one temporary file or folder.
 
 The returned string is different on every call. It is created by combining the result from temporaryPath with a unique UUID.
 
 @return The generated temporary path.
 */
+ (NSString *)zd_pathForTemporaryFile;

/** Appends or Increments a sequence number in brackets
 
 If the receiver already has a number suffix then it is incremented. If not then (1) is added.
 
 @return The incremented path
 */
- (NSString *)zd_pathByIncrementingSequenceNumber;

/** Removes a sequence number in brackets
 
 If the receiver number suffix then it is removed. If not the receiver is returned.
 
 @return The modified path
 */
- (NSString *)zd_pathByDeletingSequenceNumber;

@end

NS_ASSUME_NONNULL_END






















