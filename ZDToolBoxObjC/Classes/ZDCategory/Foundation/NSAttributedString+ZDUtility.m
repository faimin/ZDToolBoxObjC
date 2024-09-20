//
//  NSAttributedString+ZDUtility.m
//  ZDToolBoxObjC
//
//  Created by Zero_D_Saber on 2024/9/20.
//

#import "NSAttributedString+ZDUtility.h"
#import <UIKit/UIKit.h>

@implementation NSAttributedString (ZDUtility)

- (CGSize)zd_size:(CGSize)constrainedSize {
    if (!constrainedSize.width || !constrainedSize.height) {
        return CGSizeZero;
    }

    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:constrainedSize];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager glyphRangeForTextContainer:textContainer];
    CGSize size = [layoutManager usedRectForTextContainer:textContainer].size;
    return size;
}

@end
