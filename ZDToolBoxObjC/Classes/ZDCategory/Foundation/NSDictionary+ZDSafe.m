//
//  NSDictionary+ZDSafe.m
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/4/17.
//

#import "NSDictionary+ZDSafe.h"

@implementation NSDictionary (ZDSafe)

+ (nullable id)zd_dictionary:(NSDictionary *)dict objectForKey:(NSString *)aKey defaultValue:(nullable id)value {
    if (!dict) {
        return value;
    }

    return [dict zd_objectForKey:aKey defaultValue:value];
}

+ (nullable NSString *)zd_dictionary:(NSDictionary *)dict stringForKey:(NSString *)aKey defaultValue:(nullable NSString *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_stringForKey:aKey defaultValue:value];
}

+ (nullable NSArray *)zd_dictionary:(NSDictionary *)dict arrayForKey:(NSString *)aKey defaultValue:(nullable NSArray *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_arrayForKey:aKey defaultValue:value];
}

+ (nullable NSDictionary *)zd_dictionary:(NSDictionary *)dict dictionaryForKey:(NSString *)aKey defaultValue:(nullable NSDictionary *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_dictionaryForKey:aKey defaultValue:value];
}

+ (nullable NSData *)zd_dictionary:(NSDictionary *)dict dataForKey:(NSString *)aKey defaultValue:(nullable NSData *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_dataForKey:aKey defaultValue:value];
}

+ (nullable NSDate *)zd_dictionary:(NSDictionary *)dict dateForKey:(NSString *)aKey defaultValue:(nullable NSDate *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_dateForKey:aKey defaultValue:value];
}

+ (nullable NSNumber *)zd_dictionary:(NSDictionary *)dict numberForKey:(NSString *)aKey defaultValue:(nullable NSNumber *)value {
    if (!dict) {
        return value;
    }

    return [dict zd_numberForKey:aKey defaultValue:value];
}

+ (NSUInteger)zd_dictionary:(NSDictionary *)dict unsignedIntegerForKey:(NSString *)aKey defaultValue:(NSUInteger)value {
    if (!dict) {
        return value;
    }

    return [dict zd_unsignedIntegerForKey:aKey defaultValue:value];
}

+ (NSInteger)zd_dictionary:(NSDictionary *)dict integerForKey:(NSString *)aKey defaultValue:(NSInteger)value {
    if (!dict) {
        return value;
    }

    return [dict zd_integerForKey:aKey defaultValue:value];
}

+ (float)zd_dictionary:(NSDictionary *)dict floatForKey:(NSString *)aKey defaultValue:(float)value {
    if (!dict) {
        return value;
    }

    return [dict zd_floatForKey:aKey defaultValue:value];
}

+ (double)zd_dictionary:(NSDictionary *)dict doubleForKey:(NSString *)aKey defaultValue:(double)value {
    if (!dict) {
        return value;
    }

    return [dict zd_doubleForKey:aKey defaultValue:value];
}

+ (long long)zd_dictionary:(NSDictionary *)dict longLongValueForKey:(NSString *)aKey defaultValue:(long long)value {
    if (!dict) {
        return value;
    }

    return [dict zd_longLongValueForKey:aKey defaultValue:value];
}

+ (BOOL)zd_dictionary:(NSDictionary *)dict boolForKey:(NSString *)aKey defaultValue:(BOOL)value {
    if (!dict) {
        return value;
    }

    return [dict zd_boolForKey:aKey defaultValue:value];
}

+ (int)zd_dictionary:(NSDictionary *)dict intForKey:(NSString *)aKey defaultValue:(int)value {
    if (!dict) {
        return value;
    }

    return [dict zd_intForKey:aKey defaultValue:value];
}

@end
