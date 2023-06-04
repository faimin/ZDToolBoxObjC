//
//  NSArray+ZDSafe.m
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/4/17.
//

#import <objc/runtime.h>
#import "NSArray+ZDSafe.h"

@implementation NSArray (ZDSafe)

#pragma mark - safe

- (id)zd_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }

    return [self objectAtIndex:index];
}

#pragma mark - other

- (id)zd_objectAtIndex:(NSUInteger)index kindOfClass:(Class)aClass {
    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        return [obj isKindOfClass:aClass] ? obj : nil;
    }

    return nil;
}

- (id)zd_objectAtIndex:(NSUInteger)index memberOfClass:(Class)aClass {
    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        return [obj isMemberOfClass:aClass] ? obj : nil;
    }

    return nil;
}

- (id)zd_objectAtIndex:(NSUInteger)index defaultValue:(id)value {
    id obj = nil;

    if (index < [self count]) {
        obj = [self objectAtIndex:index];

        if (obj == [NSNull null]) {
            return value;
        }
    }

    return nil == obj ? value : obj;
}

- (NSString *)zd_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)value {
    NSString *str = [self zd_objectAtIndex:index kindOfClass:[NSString class]];

    return nil == str ? value : str;
}

- (NSNumber *)zd_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)value {
    NSNumber *number = [self zd_objectAtIndex:index kindOfClass:[NSNumber class]];

    return nil == number ? value : number;
}

- (NSDictionary *)zd_dictionaryAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)value {
    NSDictionary *dict = [self zd_objectAtIndex:index kindOfClass:[NSDictionary class]];

    return nil == dict ? value : dict;
}

- (NSArray *)zd_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)value {
    NSArray *array = [self zd_objectAtIndex:index kindOfClass:[NSArray class]];

    return nil == array ? value : array;
}

- (NSData *)zd_dataAtIndex:(NSUInteger)index defaultValue:(NSData *)value {
    NSData *data = [self zd_objectAtIndex:index kindOfClass:[NSData class]];

    return nil == data ? value : data;
}

- (NSDate *)zd_dateAtIndex:(NSUInteger)index defaultValue:(NSDate *)value {
    NSDate *date = [self zd_objectAtIndex:index kindOfClass:[NSDate class]];

    return nil == date ? value : date;
}

- (float)zd_floatAtIndex:(NSUInteger)index defaultValue:(float)value {
    float f = value;

    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        f = [obj respondsToSelector:@selector(floatValue)] ? [obj floatValue] : value;
    }

    return f;
}

- (double)zd_doubleAtIndex:(NSUInteger)index defaultValue:(double)value {
    double d = value;

    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        d = [obj respondsToSelector:@selector(doubleValue)] ? [obj doubleValue] : value;
    }

    return d;
}

- (NSInteger)zd_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)value {
    NSInteger i = value;

    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        i = [obj respondsToSelector:@selector(integerValue)] ? [obj integerValue] : value;
    }

    return i;
}

- (NSUInteger)zd_unintegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)value {
    NSUInteger u = value;

    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        u = [obj respondsToSelector:@selector(unsignedIntegerValue)] ? [obj unsignedIntegerValue] : value;
    }

    return u;
}

- (BOOL)zd_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)value {
    BOOL b = value;

    if (index < [self count]) {
        id obj = [self objectAtIndex:index];
        b = [obj respondsToSelector:@selector(boolValue)] ? [obj boolValue] : value;
    }

    return b;
}

#pragma mark -

+ (id)zd_array:(NSArray *)array objectAtIndex:(NSUInteger)index defaultValue:(id)value {
    if (!array) {
        return value;
    }

    return [array zd_objectAtIndex:index defaultValue:value];
}

+ (NSString *)zd_array:(NSArray *)array stringAtIndex:(NSUInteger)index defaultValue:(NSString *)value {
    if (!array) {
        return value;
    }

    return [array zd_stringAtIndex:index defaultValue:value];
}

+ (NSNumber *)zd_array:(NSArray *)array numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)value {
    if (!array) {
        return value;
    }

    return [array zd_numberAtIndex:index defaultValue:value];
}

+ (NSDictionary *)zd_array:(NSArray *)array dictionaryAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)value {
    if (!array) {
        return value;
    }

    return [array zd_dictionaryAtIndex:index defaultValue:value];
}

+ (NSArray *)zd_array:(NSArray *)array arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)value {
    if (!array) {
        return value;
    }

    return [array zd_arrayAtIndex:index defaultValue:value];
}

+ (NSData *)zd_array:(NSArray *)array dataAtIndex:(NSUInteger)index defaultValue:(NSData *)value {
    if (!array) {
        return value;
    }

    return [array zd_dataAtIndex:index defaultValue:value];
}

+ (NSDate *)zd_array:(NSArray *)array dateAtIndex:(NSUInteger)index defaultValue:(NSDate *)value {
    if (!array) {
        return value;
    }

    return [array zd_dateAtIndex:index defaultValue:value];
}

+ (float)zd_array:(NSArray *)array floatAtIndex:(NSUInteger)index defaultValue:(float)value {
    if (!array) {
        return value;
    }

    return [array zd_floatAtIndex:index defaultValue:value];
}

+ (double)zd_array:(NSArray *)array doubleAtIndex:(NSUInteger)index defaultValue:(double)value {
    if (!array) {
        return value;
    }

    return [array zd_doubleAtIndex:index defaultValue:value];
}

+ (NSInteger)zd_array:(NSArray *)array integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)value {
    if (!array) {
        return value;
    }

    return [array zd_integerAtIndex:index defaultValue:value];
}

+ (NSUInteger)zd_array:(NSArray *)array unintegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)value {
    if (!array) {
        return value;
    }

    return [array zd_unintegerAtIndex:index defaultValue:value];
}

+ (BOOL)zd_array:(NSArray *)array boolAtIndex:(NSUInteger)index defaultValue:(BOOL)value {
    if (!array) {
        return value;
    }

    return [array zd_boolAtIndex:index defaultValue:value];
}

@end

@implementation NSMutableArray (ZDSafe)

#pragma mark - Safe

- (id)zd_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return nil;
    }

    return [self objectAtIndex:index];
}

- (void)zd_addObject:(id)anObject {
    if (!anObject) {
        return;
    }

    [self addObject:anObject];
}

- (void)zd_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    }

    [self insertObject:anObject atIndex:index];
}

- (void)zd_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        return;
    }

    [self removeObjectAtIndex:index];
}

#pragma mark - Other

- (void)zd_removeObjectAtIndexInBoundary:(NSUInteger)index {
    if (index < [self count]) {
        [self removeObjectAtIndex:index];
    }
}

- (void)zd_insertObject:(id)anObject atIndexInBoundary:(NSUInteger)index {
    if (index <= [self count] && nil != anObject) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)zd_replaceObjectAtInBoundaryIndex:(NSUInteger)index withObject:(id)anObject {
    if (index < [self count] && nil != anObject) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)zd_addObjectSafe:(id)anObject {
    if (anObject && anObject != [NSNull class]) {
        [self addObject:anObject];
    }
}

@end
