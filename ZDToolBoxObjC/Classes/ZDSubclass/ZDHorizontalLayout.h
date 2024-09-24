//
//  ZDHorizontalLayout.h
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDHorizontalLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger maxColumn;
@property (nonatomic, assign) NSInteger maxRow;
@property (nonatomic, assign) CGFloat itemMargin;
@property (nonatomic, assign) CGFloat lineMargin;
@property (nonatomic, assign) CGFloat itemRatio;// height/width
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) NSInteger itemOffset; //第一行偏移个数

- (CGSize)getItemSize;

@end

NS_ASSUME_NONNULL_END
