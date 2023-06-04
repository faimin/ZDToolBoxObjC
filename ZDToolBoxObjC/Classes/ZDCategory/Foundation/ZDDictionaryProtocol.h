//
//  ZDDictionaryProtocol.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/5/29.
//

#ifndef ZDDictionaryProtocol_h
#define ZDDictionaryProtocol_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 实现该协议的类，可以使用ZDDictionaryAdapter系列方法增强数据访问
 */
@protocol ZDDictionarySetProtocol <NSObject>
@required
- (void)setObject:(id _Nullable)value forKey:(id)aKey;

@optional
// 这部分协议不需要实现，由NSObjcet内部私有实现
- (void)zd_setObject:(id _Nullable)value forKey:(id)aKey;
- (void)zd_setString:(NSString * _Nullable)value forKey:(NSString *)aKey;
- (void)zd_setNumber:(NSNumber * _Nullable)value forKey:(NSString *)aKey;
- (void)zd_setInteger:(NSInteger)value forKey:(NSString *)aKey;
- (void)zd_setInt:(int)value forKey:(NSString *)aKey;
- (void)zd_setFloat:(float)value forKey:(NSString *)aKey;
- (void)zd_setDouble:(double)value forKey:(NSString *)aKey;
- (void)zd_setLongLongValue:(long long)value forKey:(NSString *)aKey;
- (void)zd_setBool:(BOOL)value forKey:(NSString *)aKey;
@end


@protocol ZDDictionaryGetProtocol <NSObject>
@required
- (id _Nullable)objectForKey:(id)aKey;

@optional
// 这部分协议不需要实现，由NSObjcet内部私有实现
- (id _Nullable)zd_objectForKey:(NSString *)aKey defaultValue:(id _Nullable)value;
- (NSString * _Nullable)zd_stringForKey:(NSString *)aKey defaultValue:(NSString * _Nullable)value;
- (NSArray * _Nullable)zd_arrayForKey:(NSString *)aKey defaultValue:(NSArray * _Nullable)value;
- (NSDictionary * _Nullable)zd_dictionaryForKey:(NSString *)aKey defaultValue:(NSDictionary * _Nullable)value;
- (NSData * _Nullable)zd_dataForKey:(NSString *)aKey defaultValue:(NSData * _Nullable)value;
- (NSDate * _Nullable)zd_dateForKey:(NSString *)aKey defaultValue:(NSDate * _Nullable)value;
- (NSNumber * _Nullable)zd_numberForKey:(NSString *)aKey defaultValue:(NSNumber * _Nullable)value;
- (NSUInteger)zd_unsignedIntegerForKey:(NSString *)aKey defaultValue:(NSUInteger)value;
- (NSInteger)zd_integerForKey:(NSString *)aKey defaultValue:(NSInteger)value;
- (float)zd_floatForKey:(NSString *)aKey defaultValue:(float)value;
- (double)zd_doubleForKey:(NSString *)aKey defaultValue:(double)value;
- (long long)zd_longLongValueForKey:(NSString *)aKey defaultValue:(long long)value;
- (BOOL)zd_boolForKey:(NSString *)aKey defaultValue:(BOOL)value;
- (int)zd_intForKey:(NSString *)aKey defaultValue:(int)value;

@end

NS_ASSUME_NONNULL_END

#endif /* ZDDictionaryProtocol_h */
