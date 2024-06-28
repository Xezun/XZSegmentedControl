//
//  XZSegmentedControlFlowLayout.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlFlowLayout.h"
#import "XZSegmentedControlIndicatorView.h"

#define UICollectionElementKindIndicator @"indicator"
#define kIndicatorWidth  3.0

@implementation XZSegmentedControlFlowLayout {
    XZSegmentedControlIndicatorLayoutAttributes *_indicatorLayoutAttributes;
    Class _currentIndicatorClass;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _currentIndicatorClass = [XZSegmentedControlIndicatorView class];
        [self registerClass:_currentIndicatorClass forDecorationViewOfKind:UICollectionElementKindIndicator];
    }
    return self;
}

- (UIColor *)indicatorColor {
    return _indicatorLayoutAttributes.color;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorLayoutAttributes.color = indicatorColor;
    [self invalidateIndicaotrLayout];
}

- (UIImage *)indicatorImage {
    return _indicatorLayoutAttributes.image;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    _indicatorLayoutAttributes.image = indicatorImage;
    if (indicatorImage != nil && (_indicatorSize.width == 0 || _indicatorSize.height == 0)) {
        self.indicatorSize = indicatorImage.size;
    }
    [self invalidateIndicaotrLayout];
}

- (void)setIndicatorStyle:(XZSegmentedControlIndicatorStyle)indicatorStyle {
    if (_indicatorStyle != indicatorStyle) {
        _indicatorStyle = indicatorStyle;
        [self __xz_updateCurrentIndicatorClass];
        [self prepareIndicaotrLayout:YES];
        [self invalidateIndicaotrLayout];
    }
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    if (!CGSizeEqualToSize(_indicatorSize, indicatorSize)) {
        _indicatorSize = indicatorSize;
        [self prepareIndicaotrLayout:YES];
        [self invalidateIndicaotrLayout];
    }
}

- (void)setIndicatorClass:(Class)indicatorClass {
    NSParameterAssert([indicatorClass isKindOfClass:UICollectionReusableView.class]);
    if (_indicatorClass != indicatorClass) {
        _indicatorClass = indicatorClass;
        [self __xz_updateCurrentIndicatorClass];
    }
}

- (void)__xz_updateCurrentIndicatorClass {
    Class newClass = nil;
    if (_indicatorStyle == XZSegmentedControlIndicatorStyleCustom) {
        newClass = (_indicatorClass != Nil ? _indicatorClass : [XZSegmentedControlIndicatorView class]);
    } else {
        newClass = [XZSegmentedControlIndicatorView class];
    }
    if (newClass != _currentIndicatorClass) {
        _currentIndicatorClass = newClass;
        [self registerClass:newClass forDecorationViewOfKind:UICollectionElementKindIndicator];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        // 更新布局
        [self prepareIndicaotrLayout:animated];
        [self invalidateIndicaotrLayout];
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    [self prepareIndicaotrLayout:NO];
}

- (void)prepareIndicaotrLayout:(BOOL)animated {
    NSInteger const count = [self.collectionView numberOfItemsInSection:0];
    
    if (_indicatorLayoutAttributes == nil) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        _indicatorLayoutAttributes = [XZSegmentedControlIndicatorLayoutAttributes layoutAttributesForDecorationViewOfKind:UICollectionElementKindIndicator withIndexPath:indexPath];
    }
    
    switch (_indicatorStyle) {
        case XZSegmentedControlIndicatorStyleMarkLine: {
            _indicatorLayoutAttributes.zIndex = NSIntegerMax;
            if (count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
                
                CGRect const frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal: {
                        CGFloat const h = _indicatorSize.height > 0 ? _indicatorSize.height : kIndicatorWidth;
                        CGFloat const w = _indicatorSize.width > 0 ? _indicatorSize.width : (_indicatorSize.width + frame.size.width);
                        CGFloat const x = frame.origin.x + (frame.size.width - w) * 0.5;
                        CGFloat const y = CGRectGetMaxY(frame) - h;
                        _indicatorLayoutAttributes.frame = CGRectMake(x, y, w, h);
                        break;
                    }
                    case UICollectionViewScrollDirectionVertical: {
                        CGFloat const w = _indicatorSize.width > 0 ? _indicatorSize.width : kIndicatorWidth;
                        CGFloat const h = _indicatorSize.height > 0 ? _indicatorSize.height : (_indicatorSize.height + frame.size.height);
                        CGFloat const y = frame.origin.y + (frame.size.height - h) * 0.5;
                        CGFloat const x = CGRectGetMaxX(frame) - w;
                        _indicatorLayoutAttributes.frame = CGRectMake(x, y, w, h);
                        break;
                    }
                    default:
                        break;
                }
            } else {
                CGRect const bounds = self.collectionView.bounds;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMaxY(bounds) - kIndicatorWidth, 0, kIndicatorWidth);
                        break;
                    case UICollectionViewScrollDirectionVertical:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMaxX(bounds) - kIndicatorWidth, CGRectGetMinY(bounds), kIndicatorWidth, 0);
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case XZSegmentedControlIndicatorStyleLeadLine: {
            _indicatorLayoutAttributes.zIndex = NSIntegerMax;
            if (count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
                
                CGRect const frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal: {
                        CGFloat const h = _indicatorSize.height > 0 ? _indicatorSize.height : kIndicatorWidth;
                        CGFloat const w = _indicatorSize.width > 0 ? _indicatorSize.width : (_indicatorSize.width + frame.size.width);
                        CGFloat const x = frame.origin.x + (frame.size.width - w) * 0.5;
                        CGFloat const y = CGRectGetMinY(frame);
                        _indicatorLayoutAttributes.frame = CGRectMake(x, y, w, h);
                        break;
                    }
                    case UICollectionViewScrollDirectionVertical: {
                        CGFloat const w = _indicatorSize.width > 0 ? _indicatorSize.width : kIndicatorWidth;
                        CGFloat const h = _indicatorSize.height > 0 ? _indicatorSize.height : (_indicatorSize.height + frame.size.height);
                        CGFloat const y = frame.origin.y + (frame.size.height - h) * 0.5;
                        CGFloat const x = CGRectGetMinX(frame);
                        _indicatorLayoutAttributes.frame = CGRectMake(x, y, w, h);
                        break;
                    }
                    default:
                        break;
                }
            } else {
                CGRect const bounds = self.collectionView.bounds;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), 0, kIndicatorWidth);
                        break;
                    case UICollectionViewScrollDirectionVertical:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), kIndicatorWidth, 0);
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case XZSegmentedControlIndicatorStyleCustom: {
            if (count > 0) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
                
                CGRect const frame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
                _indicatorLayoutAttributes.frame = frame;
            } else {
                CGRect const bounds = self.collectionView.bounds;
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), 0, CGRectGetHeight(bounds));
                        break;
                    case UICollectionViewScrollDirectionVertical:
                        _indicatorLayoutAttributes.frame = CGRectMake(CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetWidth(bounds), 0);
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        default:
            break;
    }
    
    
}

- (void)invalidateIndicaotrLayout {
    // 标记更新
    UICollectionViewFlowLayoutInvalidationContext *context = [[UICollectionViewFlowLayoutInvalidationContext alloc] init];
    context.invalidateFlowLayoutAttributes      = NO;
    context.invalidateFlowLayoutDelegateMetrics = NO;
    [context invalidateDecorationElementsOfKind:UICollectionElementKindIndicator atIndexPaths:@[
        [NSIndexPath indexPathForItem:0 inSection:0]
    ]];
    [self invalidateLayoutWithContext:context];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *items = [super layoutAttributesForElementsInRect:rect];
    return [items arrayByAddingObject:_indicatorLayoutAttributes];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:UICollectionElementKindIndicator]) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return _indicatorLayoutAttributes;
        }
    }
    return nil;
}

- (UIUserInterfaceLayoutDirection)developmentLayoutDirection {
    return UIUserInterfaceLayoutDirectionLeftToRight;
}

- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return YES;
}

@end


