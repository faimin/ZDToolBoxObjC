//
//  UIView+ZDConstraint.m
//  ZDToolBoxObjC
//
//  Created by Zero_D_Saber on 2024/11/18.
//

#import "UIView+ZDConstraint.h"
#import <objc/runtime.h>

@implementation UIView (ZDConstraint)

#pragma mark - Constraints

/*
- (NSLayoutConstraint *)zd_constraintForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && (firstItem = %@ || secondItem = %@)", attribute, self, self];
    NSArray *constraintArray = [self.superview constraints];
    
    if (attribute == NSLayoutAttributeWidth || attribute == NSLayoutAttributeHeight) {
        constraintArray = [self constraints];
    }
    
    NSArray *fillteredArray = [constraintArray filteredArrayUsingPredicate:predicate];
    return fillteredArray.firstObject;
}
*/

- (void)zd_foldConstraint:(BOOL)fold attributes:(NSLayoutAttribute)attributes, ...NS_REQUIRES_NIL_TERMINATION {
    va_list ap;
    va_start(ap, attributes);
    
    if (attributes) {
        [self zd_foldConstraint:fold attribute:attributes];
        
        NSLayoutAttribute detailAttribute;
        while ((detailAttribute = va_arg(ap, NSLayoutAttribute))) {
            [self zd_foldConstraint:!self.hidden attribute:detailAttribute];
        }
    }
    
    va_end(ap);
    self.hidden = !self.hidden;
}

- (void)zd_foldConstraint:(BOOL)fold attribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self zd_constraintForAttribute:attribute];
    if (!constraint) {
        return;
    }
    
    NSString *constraintString = [self zd_attributeToString:attribute];
    NSNumber *originConstant = objc_getAssociatedObject(self, constraintString.UTF8String);
    if (!originConstant) {
        objc_setAssociatedObject(self, [constraintString UTF8String], @(constraint.constant), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        originConstant = @(constraint.constant);
    }
    
    if (fold) {
        constraint.constant = 0;
    } else {
        constraint.constant = originConstant.floatValue;
    }
}

- (CGFloat)zd_constraintConstantForAttribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self zd_constraintForAttribute:attribute];
    if (constraint) {
        return constraint.constant;
    } else {
        return NAN;
    }
}

- (NSLayoutConstraint *)zd_constraintForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", attribute, self];
    
    NSArray<__kindof NSLayoutConstraint *> *constraints= self.superview.constraints;
    NSArray<__kindof NSLayoutConstraint *> *filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    NSLayoutConstraint *constraint = filteredArray.firstObject;
    if (constraint) {
        return constraint;
    }
    
    NSArray *selfFilteredArray = [self.constraints filteredArrayUsingPredicate:predicate];
    return selfFilteredArray.firstObject;
}

- (NSString *)zd_attributeToString:(NSLayoutAttribute)attribute {
    NSDictionary<NSNumber *, NSString *> *attributeMap = @{
        @(NSLayoutAttributeLeft): @"NSLayoutAttributeLeft",
        @(NSLayoutAttributeRight): @"NSLayoutAttributeRight",
        @(NSLayoutAttributeTop): @"NSLayoutAttributeTop",
        @(NSLayoutAttributeBottom): @"NSLayoutAttributeBottom",
        @(NSLayoutAttributeLeading): @"NSLayoutAttributeLeading",
        @(NSLayoutAttributeTrailing): @"NSLayoutAttributeTrailing",
        @(NSLayoutAttributeWidth): @"NSLayoutAttributeWidth",
        @(NSLayoutAttributeHeight): @"NSLayoutAttributeHeight",
        @(NSLayoutAttributeCenterX): @"NSLayoutAttributeCenterX",
        @(NSLayoutAttributeCenterY): @"NSLayoutAttributeCenterY",
        @(NSLayoutAttributeBaseline): @"NSLayoutAttributeBaseline",
        @(NSLayoutAttributeFirstBaseline): @"NSLayoutAttributeFirstBaseline",
        @(NSLayoutAttributeLeftMargin): @"NSLayoutAttributeLeftMargin",
        @(NSLayoutAttributeRightMargin): @"NSLayoutAttributeRightMargin",
        @(NSLayoutAttributeLeadingMargin): @"NSLayoutAttributeLeadingMargin",
        @(NSLayoutAttributeTrailingMargin): @"NSLayoutAttributeTrailingMargin",
        @(NSLayoutAttributeTopMargin): @"NSLayoutAttributeTopMargin",
        @(NSLayoutAttributeBottomMargin): @"NSLayoutAttributeBottomMargin",
        @(NSLayoutAttributeCenterXWithinMargins): @"NSLayoutAttributeCenterXWithinMargins",
        @(NSLayoutAttributeCenterYWithinMargins): @"NSLayoutAttributeCenterYWithinMargins",
        @(NSLayoutAttributeNotAnAttribute): @"NSLayoutAttributeNotAnAttribute",
    };
    NSString *value = attributeMap[@(attribute)] ?: @"NSLayoutAttributeNotAnAttribute";
    return value;
}

@end
