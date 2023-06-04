//
//  NSObject+ZDDictionaryAdapterPrivite.m
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/5/29.
//

#import "NSObject+ZDDictionaryAdapterPrivite.h"
#import "ZDDictionaryProtocol.h"

@implementation NSObject (ZDDictionaryAdapterPrivite)

- (void)zd_printCurrentCallStack {
    NSArray *callArray = [NSThread callStackSymbols];
    NSLog(@"\n -----------------------------------------❌call stack❌----------------------------------------------\n");
    for (NSString *string in callArray) {
        NSLog(@"  %@  ", string);
    }
    NSLog(@"\n -------------------------------------------------------------------------------------------------\n");
}

#pragma mark - ZDDictionaryGetProtocol

- (id)zd_objectForKey:(NSString *)key defaultValue:(id)defaultValue {
    if ([self respondsToSelector:@selector(objectForKey:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        id obj = [(NSDictionary *)self objectForKey:key];
#pragma clang diagnostic pop
        return (obj && obj != [NSNull null]) ? obj : defaultValue;
    }
    else {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"self can't implementation -[objectForKey:], the receiver's class is:%@, The key is %@, the defaultValue is :%@", key, [self class], defaultValue];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSString *)zd_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:NSString.class]) {
        return (NSString *)obj;
    }
    else if ([obj isKindOfClass:NSNumber.class]) {
        //抛出警告
        {
            NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSString", __func__, key, obj];
            NSDictionary *userInfo = @{
                @"key" : @"iOS_IllegalType_Log",
                @"content" : reason,
                @"type" : @"NSString",
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDToolKit_NSDictionary_Type_Error" object:nil userInfo:userInfo];
        }
        
        // 处理 NSNumber -> NSString
        return [(NSNumber *)obj stringValue];
    }
    else {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSString, the value's actual type is:%@", key, obj, [obj class]];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSArray *)zd_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:NSArray.class]) {
        return (NSArray *)obj;
    }
    else if ( ([obj isKindOfClass:[NSDictionary class]] && [(NSDictionary *)obj count] == 0)
             ||
             ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length] == 0))
    {
        NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSArray", __func__, key, obj];
        NSDictionary *userInfo = @{
            @"key" : @"iOS_IllegalType_Log",
            @"content" : reason,
            @"type" : @"NSArray",
        };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDToolKit_NSDictionary_Type_Error" object:nil userInfo:userInfo];
    }
    else {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSArray, value's actual type is:%@", key, obj, [obj class]];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSDictionary *)zd_dictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:NSDictionary.class]) {
        return (NSDictionary *)obj;
    }
    else if ( ([obj isKindOfClass:[NSArray class]] && [(NSArray *)obj count] == 0)
             ||
             ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length] == 0) ) {
             {
                 NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSDictionary", __func__, key, obj];
                 NSDictionary *userInfo = @{
                     @"key" : @"iOS_IllegalType_Log",
                     @"content" : reason,
                     @"type" : @"NSDictionary",
                 };
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDToolKit_NSDictionary_Type_Error" object:nil userInfo:userInfo];
             }
    }
    else {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSDictionary, the value's actual type is:%@", key, obj, [obj class]];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSData *)zd_dataForKey:(NSString *)key defaultValue:(NSData *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (obj && ![obj isKindOfClass:[NSData class]]) {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSData, the value's type is:%@", key, obj, [obj class]];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSDate *)zd_dateForKey:(NSString *)key defaultValue:(NSDate *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:NSDate.class]) {
        return (NSDate *)obj;
    }
    [self zd_printCurrentCallStack];
    NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSDate, the value's actual type is:%@", key, obj, [obj class]];
    NSLog(@"❌%@", reason);
    return defaultValue;
}

- (NSNumber *)zd_numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:defaultValue];
    if (!obj) {
        return defaultValue;
    }
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        return (NSNumber *)obj;
    }
    else if ([obj isKindOfClass:[NSString class]]) {
        //抛出警告
        {
            NSString *reason = [NSString stringWithFormat:@"%s, The key is \" %@ \", the value is \" %@ \", need type is NSNumber", __func__, key, obj];
            NSDictionary *userInfo = @{
                @"key" : @"iOS_IllegalType_Log",
                @"content" : reason,
                @"type" : @"NSNumber",
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDToolKit_NSDictionary_Type_Error" object:nil userInfo:userInfo];
        }
        
        // 处理 NSString -> NSNumber
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *number = [numberFormatter numberFromString:(NSString *)obj];
        return number ?: defaultValue;
    }
    else {
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The key is \" %@ \", the value is \" %@ \", need type is NSNumber, the value's actual type is:%@", key, obj, [obj class]];
        NSLog(@"❌%@", reason);
    }
    return defaultValue;
}

- (NSUInteger)zd_unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(unsignedIntegerValue)]) {
        return [obj unsignedIntegerValue];
    }
    
    return defaultValue;
}

- (int)zd_intForKey:(NSString *)key defaultValue:(int)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(intValue)]) {
        return [obj intValue];
    }
    
    return defaultValue;
}

- (NSInteger)zd_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(integerValue)]) {
        return [obj integerValue];
    }
    
    return defaultValue;
}

- (float)zd_floatForKey:(NSString *)key defaultValue:(float)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(floatValue)]) {
        return [obj floatValue];
    }
    
    return defaultValue;
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(doubleValue)]) {
        return [obj doubleValue];
    }
    
    return defaultValue;
}

- (long long)zd_longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(longLongValue)]) {
        return [obj longLongValue];
    }
    
    return defaultValue;
}

- (BOOL)zd_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue {
    id obj = [self zd_objectForKey:key defaultValue:nil];
    if ([obj respondsToSelector:@selector(boolValue)]) {
        return [obj boolValue];
    }
    
    return defaultValue;
}

#pragma mark - ZDDictionarySetProtocol

- (void)zd_setObject:(id)value forKey:(id)key {
    if (!value || !key || value == [NSNull null] || key == [NSNull null]) {
        return;
    }
    
    if ([self respondsToSelector:@selector(setObject:forKey:)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-method-access"
        [(NSMutableDictionary *)self setObject:value forKey:key];
#pragma clang diagnostic pop
    }
    else {
        //NSLog(@"Error, called function %s with illegal parameters, The key is:%@, The value is:%@", __func__, key, value);
        [self zd_printCurrentCallStack];
        NSString *reason = [NSString stringWithFormat:@"The receiver's type is:%@,The key is %@, the value is :%@", [self class], key, value];
        NSLog(@"❌%@", reason);
    }
}

- (void)zd_setString:(NSString *)value forKey:(NSString *)key {
    [self zd_setObject:value forKey:key];
}

- (void)zd_setNumber:(NSNumber *)value forKey:(NSString *)key {
    [self zd_setObject:value forKey:key];
}

- (void)zd_setInteger:(NSInteger)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithInteger:value] forKey:key];
}

- (void)zd_setInt:(int)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithInt:value] forKey:key];
}

- (void)zd_setFloat:(float)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (void)zd_setDouble:(double)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithDouble:value] forKey:key];
}

- (void)zd_setLongLongValue:(long long)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithLongLong:value] forKey:key];
}

- (void)zd_setBool:(BOOL)value forKey:(NSString *)key {
    [self zd_setObject:[NSNumber numberWithBool:value] forKey:key];
}

@end
