//
//  NSDictionary+ZDSafe.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/4/17.
//

#import <Foundation/Foundation.h>
#import "ZDDictionaryProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<KeyType, ObjectType> (ZDSafe) <ZDDictionaryGetProtocol>

+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict objectForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict stringForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict arrayForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict dictionaryForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict dataForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict dateForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict numberForKey:(KeyType)aKey defaultValue:(ObjectType _Nullable)value;
+ (NSUInteger)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict unsignedIntegerForKey:(KeyType)aKey defaultValue:(NSUInteger)value;
+ (NSInteger)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict integerForKey:(KeyType)aKey defaultValue:(NSInteger)value;
+ (float)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict floatForKey:(KeyType)aKey defaultValue:(float)value;
+ (double)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict doubleForKey:(KeyType)aKey defaultValue:(double)value;
+ (long long)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict longLongValueForKey:(KeyType)aKey defaultValue:(long long)value;
+ (BOOL)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict boolForKey:(KeyType)aKey defaultValue:(BOOL)value;
+ (int)zd_dictionary:(NSDictionary<KeyType, ObjectType> *)dict intForKey:(KeyType)aKey defaultValue:(int)value;

@end

NS_ASSUME_NONNULL_END
