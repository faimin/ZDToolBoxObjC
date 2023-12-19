//
//  NSObject+ZDDictionaryAdapterPrivite.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/5/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZDDictionaryAdapterPrivite)

#pragma mark - 语法糖

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;

- (id)objectForKeyedSubscript:(id<NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
