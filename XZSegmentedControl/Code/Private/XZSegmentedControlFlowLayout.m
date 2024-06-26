//
//  XZSegmentedControlFlowLayout.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlFlowLayout.h"
#import "XZSegmentedControlIndicatorView.h"

#define kIndicatorKind   @"Indicator"
#define kIndicatorWidth  3.0

@implementation XZSegmentedControlFlowLayout {
    XZSegmentedControlIndicatorLayoutAttributes *_indicatorLayoutAttributes;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _indicatorClass = [XZSegmentedControlIndicatorView class];
        [self registerClass:_indicatorClass forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
    }
    return self;
}

- (UIColor *)indicatorColor {
    return _indicatorLayoutAttributes.color;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorLayoutAttributes.color = indicatorColor;
}

- (UIImage *)indicatorImage {
    return _indicatorLayoutAttributes.image;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    if (indicatorImage != nil && (_indicatorSize.width == 0 || _indicatorSize.height == 0)) {
        self.indicatorSize = indicatorImage.size;
    }
    _indicatorLayoutAttributes.image = indicatorImage;
}

- (void)setIndicatorStyle:(XZSegmentedControlIndicatorStyle)indicatorStyle {
    if (_indicatorStyle != indicatorStyle) {
        _indicatorStyle = indicatorStyle;
        
        if (_indicatorStyle != XZSegmentedControlIndicatorStyleCustom) {
            if (_indicatorClass != [XZSegmentedControlIndicatorView class]) {
                self.indicatorClass = [XZSegmentedControlIndicatorView class];
                return;
            }
        }
        
        [self prepareIndicaotrLayout];
        [self invalidateIndicaotrLayout];
    }
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    if (!CGSizeEqualToSize(_indicatorSize, indicatorSize)) {
        _indicatorSize = indicatorSize;
        [self prepareIndicaotrLayout];
        [self invalidateIndicaotrLayout];
    }
}

- (void)setIndicatorClass:(Class)indicatorClass {
    NSParameterAssert([indicatorClass isSubclassOfClass:UICollectionReusableView.class]);
    indicatorClass = indicatorClass ?: [XZSegmentedControlIndicatorView class];
    if (_indicatorClass != indicatorClass) {
        [self registerClass:nil forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
        _indicatorClass = indicatorClass;
        [self registerClass:_indicatorClass forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
        
        // 这里仅仅刷新指示器的 attributes 存在问题：
        // 从 custom 变回内置样式，custom 的指示器会残留。
        [self invalidateLayout];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        
        // 更新布局
        [self prepareIndicaotrLayout];
        [self invalidateIndicaotrLayout];
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    [self prepareIndicaotrLayout];
}

- (void)prepareIndicaotrLayout {
    NSInteger const count = [self.collectionView numberOfItemsInSection:0];
    
    if (![_indicatorLayoutAttributes.representedElementKind isEqualToString:NSStringFromClass(_indicatorClass)]) {
        XZSegmentedControlIndicatorLayoutAttributes * const oldValue = _indicatorLayoutAttributes;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        _indicatorLayoutAttributes = [XZSegmentedControlIndicatorLayoutAttributes layoutAttributesForDecorationViewOfKind:NSStringFromClass(_indicatorClass) withIndexPath:indexPath];
        // 复制自定义属性
        if (oldValue) {
            _indicatorLayoutAttributes.delegate = oldValue.delegate;
            _indicatorLayoutAttributes.image = oldValue.image;
            _indicatorLayoutAttributes.color = oldValue.color;
        }
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
            if ([_indicatorClass respondsToSelector:@selector(collectionViewLayout:prepareLayoutForAttributes:)]) {
                [_indicatorClass collectionViewLayout:self prepareLayoutForAttributes:_indicatorLayoutAttributes];
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
    [context invalidateDecorationElementsOfKind:NSStringFromClass(_indicatorClass) atIndexPaths:@[
        [NSIndexPath indexPathForItem:0 inSection:0]
    ]];
    [self invalidateLayoutWithContext:context];
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *items = [super layoutAttributesForElementsInRect:rect];
    if (!CGRectIsEmpty(_indicatorLayoutAttributes.frame)) {
        if (CGRectIntersectsRect(rect, _indicatorLayoutAttributes.frame)) {
            items = [items arrayByAddingObject:_indicatorLayoutAttributes];
        }
    }
    return items;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0 || indexPath.item != 0) {
        return nil;
    }
    if (![elementKind isEqualToString:_indicatorLayoutAttributes.representedElementKind]) {
        return nil;
    }
    return _indicatorLayoutAttributes;
}

- (UIUserInterfaceLayoutDirection)developmentLayoutDirection {
    return UIUserInterfaceLayoutDirectionLeftToRight;
}

- (BOOL)flipsHorizontallyInOppositeLayoutDirection {
    return YES;
}

@end


