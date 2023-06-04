//
//  NSArray+ZDSafe.h
//  ZDToolKit
//
//  Created by Zero.D.Saber on 2023/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<ObjectType> (ZDSafe)

- (ObjectType _Nullable)zd_objectAtIndex:(NSUInteger)index kindOfClass:(Class)aClass;
- (ObjectType _Nullable)zd_objectAtIndex:(NSUInteger)index memberOfClass:(Class)aClass;

- (ObjectType _Nullable)zd_objectAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_stringAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_numberAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_dictionaryAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_arrayAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_dataAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (ObjectType _Nullable)zd_dateAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
- (float)zd_floatAtIndex:(NSUInteger)index defaultValue:(float)value;
- (double)zd_doubleAtIndex:(NSUInteger)index defaultValue:(double)value;
- (NSInteger)zd_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)value;
- (NSUInteger)zd_unintegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)value;
- (BOOL)zd_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)value;

+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array objectAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array stringAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array numberAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array dictionaryAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array arrayAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array dataAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (ObjectType _Nullable)zd_array:(NSArray<ObjectType> *)array dateAtIndex:(NSUInteger)index defaultValue:(ObjectType _Nullable)value;
+ (float)zd_array:(NSArray<ObjectType> *)array floatAtIndex:(NSUInteger)index defaultValue:(float)value;
+ (double)zd_array:(NSArray<ObjectType> *)array doubleAtIndex:(NSUInteger)index defaultValue:(double)value;
+ (NSInteger)zd_array:(NSArray<ObjectType> *)array integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)value;
+ (NSUInteger)zd_array:(NSArray<ObjectType> *)array unintegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)value;
+ (BOOL)zd_array:(NSArray<ObjectType> *)array boolAtIndex:(NSUInteger)index defaultValue:(BOOL)value;

@end

@interface NSMutableArray<ObjectType> (ZDSafe)

- (ObjectType)zd_objectAtIndex:(NSUInteger)index;
- (void)zd_addObject:(ObjectType)anObject;
- (void)zd_insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
- (void)zd_removeObjectAtIndex:(NSUInteger)index;
- (void)zd_removeObjectAtIndexInBoundary:(NSUInteger)index;
- (void)zd_insertObject:(ObjectType)anObject atIndexInBoundary:(NSUInteger)index;
- (void)zd_replaceObjectAtInBoundaryIndex:(NSUInteger)index withObject:(ObjectType)anObject;

// delete nil & NSNull
- (void)zd_addObjectSafe:(ObjectType)anObject;

@end

NS_ASSUME_NONNULL_END
