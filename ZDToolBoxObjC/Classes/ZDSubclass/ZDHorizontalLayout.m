//
//  ZDHorizontalLayout.m
//  ZDToolBoxObjC
//
//  Created by Zero.D.Saber on 2024/9/24.
//

#import "ZDHorizontalLayout.h"

@interface ZDHorizontalLayout ()

@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, assign) CGSize itemSize;

@end

@implementation ZDHorizontalLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _attributes = @[].mutableCopy;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [_attributes removeAllObjects];
    
    CGSize itemsize = [self getItemSize];
    CGRect mainRect = self.collectionView.bounds;
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger item = 0; item < items; ++item) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        [_attributes addObject:({
            UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat x = _contentInset.left + (itemsize.width + _itemMargin) * ((item  + _itemOffset) % _maxColumn) + (((item  + _itemOffset) /_maxColumn/_maxRow) * mainRect.size.width);
            CGFloat y = _contentInset.top + (itemsize.height + _lineMargin) * ((item  + _itemOffset) / _maxColumn %_maxRow);
            attribute.frame = CGRectMake(x, y, itemsize.width, itemsize.height);
            attribute;
        })];
    }
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray * rectAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes * attribute in _attributes) {
        if (CGRectContainsRect(rect, attribute.frame)) {
            [rectAttributes addObject:attribute];
        }
    }
    return rectAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return _attributes[indexPath.row];
}

- (CGSize)collectionViewContentSize {
    CGRect mainRect = self.collectionView.bounds;
    CGSize itemsize = [self getItemSize];
    int page = ceil(([self.collectionView numberOfItemsInSection:0] + _itemOffset)*1.0 /_maxRow/_maxColumn);
    CGSize size = CGSizeMake(page * mainRect.size.width, _contentInset.top + _contentInset.bottom + (_maxRow * (itemsize.height + _lineMargin))-_lineMargin);
    return  size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

#pragma mark - Public

- (CGSize)getItemSize {
    if (!CGSizeEqualToSize(_itemSize, CGSizeZero)) {
        return _itemSize;
    }
    CGRect mainRect = self.collectionView.bounds;
    CGFloat width = (mainRect.size.width - ((_maxColumn - 1) * _itemMargin) - _contentInset.left - _contentInset.right) / _maxColumn;
    _itemSize = CGSizeMake(width, width*_itemRatio);
    
    return _itemSize;
}

@end
