//
//  XZSegmentedControlFlowLayout.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlFlowLayout.h"
#import "XZSegmentedControlLineIndicatorView.h"

#define kIndicatorKind   @"Indicator"
#define kIndicatorWidth  3.0

@implementation XZSegmentedControlFlowLayout {
    XZSegmentedControlIndicatorLayoutAttributes * _Nonnull _indicatorLayoutAttributes;
    BOOL _needsUpdateIndicatorLayout;
}

- (instancetype)initWithSegmentedControl:(XZSegmentedControl *)segmentedControl {
    self = [super init];
    if (self != nil) {
        _needsUpdateIndicatorLayout = NO;
        _segmentedControl = segmentedControl;
        _indicatorClass = [XZSegmentedControlMarkLineIndicatorView class];
        [self registerClass:_indicatorClass forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
        [self prepareIndicatorLayoutAttributes];
    }
    return self;
}

- (UIColor *)indicatorColor {
    return _indicatorLayoutAttributes.color;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorLayoutAttributes.color = indicatorColor;
    [_indicatorLayoutAttributes.indicatorView applyLayoutAttributes:_indicatorLayoutAttributes];
}

- (UIImage *)indicatorImage {
    return _indicatorLayoutAttributes.image;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    if (indicatorImage != nil && (_indicatorSize.width == 0 || _indicatorSize.height == 0)) {
        self.indicatorSize = indicatorImage.size;
    }
    _indicatorLayoutAttributes.image = indicatorImage;
    [_indicatorLayoutAttributes.indicatorView applyLayoutAttributes:_indicatorLayoutAttributes];
}

- (void)setIndicatorStyle:(XZSegmentedControlIndicatorStyle)indicatorStyle {
    if (_indicatorStyle != indicatorStyle) {
        _indicatorStyle = indicatorStyle;
        
        switch (_indicatorStyle) {
            case XZSegmentedControlIndicatorStyleMarkLine:
                self.indicatorClass = [XZSegmentedControlMarkLineIndicatorView class];
                break;
            case XZSegmentedControlIndicatorStyleNoteLine:
                self.indicatorClass = [XZSegmentedControlNoteLineIndicatorView class];
                break;
            case XZSegmentedControlIndicatorStyleCustom:
                break;
            default:
                break;
        }
    }
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    if (!CGSizeEqualToSize(_indicatorSize, indicatorSize)) {
        _indicatorSize = indicatorSize;
        [self setNeedsUpdateIndicatorLayout:NO];
    }
}

- (void)setIndicatorClass:(Class)indicatorClass {
    if (![indicatorClass isSubclassOfClass:UICollectionReusableView.class]) {
        switch (_indicatorStyle) {
            case XZSegmentedControlIndicatorStyleMarkLine:
                indicatorClass = [XZSegmentedControlMarkLineIndicatorView class];
                break;
            case XZSegmentedControlIndicatorStyleNoteLine:
                indicatorClass = [XZSegmentedControlNoteLineIndicatorView class];
                break;
            case XZSegmentedControlIndicatorStyleCustom:
                indicatorClass = [XZSegmentedControlMarkLineIndicatorView class];
                break;
            default:
                break;
        }
    }
    if (_indicatorClass != indicatorClass) {
        [self registerClass:nil forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
        _indicatorClass = indicatorClass;
        [self registerClass:_indicatorClass forDecorationViewOfKind:NSStringFromClass(_indicatorClass)];
        
        // 这里仅仅刷新指示器的 attributes 存在问题：从 custom 变回内置样式，custom 的指示器会残留。
        [self invalidateLayout];
    }
}

- (void)setIndicatorTransition:(CGFloat)indicatorTransition {
    if (_indicatorLayoutAttributes.transition != indicatorTransition) {
        _indicatorLayoutAttributes.transition = indicatorTransition;
        
        if ([_indicatorClass supportsInteractiveTransition]) {
            [self setNeedsUpdateIndicatorLayout:NO];
        }
    }
}

- (CGFloat)indicatorTransition {
    return _indicatorLayoutAttributes.transition;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        // 更新布局
        [self setNeedsUpdateIndicatorLayout:animated];
    }
}

- (void)prepareLayout {
    [super prepareLayout];
    [self prepareIndicatorLayout];
}

- (void)setNeedsUpdateIndicatorLayout:(CGFloat)animated {
    if (_needsUpdateIndicatorLayout) {
        return;
    }
    _needsUpdateIndicatorLayout = YES;
    [NSRunLoop.mainRunLoop performInModes:@[NSRunLoopCommonModes] block:^{
        [self updateIndicaotrLayoutIfNeeded:animated];
    }];
}

- (void)updateIndicaotrLayoutIfNeeded:(BOOL)animated {
    if (!_needsUpdateIndicatorLayout) {
        return;
    }
    _needsUpdateIndicatorLayout = NO;
    
    UICollectionViewFlowLayoutInvalidationContext *context = [[UICollectionViewFlowLayoutInvalidationContext alloc] init];
    context.invalidateFlowLayoutAttributes      = NO;
    context.invalidateFlowLayoutDelegateMetrics = NO;
    [context invalidateDecorationElementsOfKind:NSStringFromClass(_indicatorClass) atIndexPaths:@[
        [NSIndexPath indexPathForItem:0 inSection:0]
    ]];
    
    [self invalidateLayoutWithContext:context];
    [self prepareIndicatorLayout];

    if (animated) {
        [_indicatorLayoutAttributes.indicatorView animateTransition:_indicatorLayoutAttributes];
    }
}

/// 更新 indicator 的布局。请不要直接调用此方法。
- (void)prepareIndicatorLayout {
    NSInteger const count = [self.collectionView numberOfItemsInSection:0];
    
    [self prepareIndicatorLayoutAttributes];
    
    switch (_indicatorStyle) {
        case XZSegmentedControlIndicatorStyleMarkLine: {
            _indicatorLayoutAttributes.zIndex = NSIntegerMax;
            if (count > 0) {
                [_indicatorClass segmentedControl:_segmentedControl prepareForLayoutAttributes:_indicatorLayoutAttributes];
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
        case XZSegmentedControlIndicatorStyleNoteLine: {
            _indicatorLayoutAttributes.zIndex = NSIntegerMax;
            if (count > 0) {
                [_indicatorClass segmentedControl:_segmentedControl prepareForLayoutAttributes:_indicatorLayoutAttributes];
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
                [_indicatorClass segmentedControl:_segmentedControl prepareForLayoutAttributes:_indicatorLayoutAttributes];
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

/// 加载指示器属性。
- (void)prepareIndicatorLayoutAttributes {
    NSString * const kind = NSStringFromClass(_indicatorClass);
    if ([_indicatorLayoutAttributes.representedElementKind isEqualToString:kind]) {
        return;
    }
    
    XZSegmentedControlIndicatorLayoutAttributes * const oldValue = _indicatorLayoutAttributes;
    
    NSIndexPath * const indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    _indicatorLayoutAttributes = [XZSegmentedControlIndicatorLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
    
    // 复制自定义属性
    if (oldValue) {
        _indicatorLayoutAttributes.indicatorView = oldValue.indicatorView;
        _indicatorLayoutAttributes.image         = oldValue.image;
        _indicatorLayoutAttributes.color         = oldValue.color;
        _indicatorLayoutAttributes.transition    = oldValue.transition;
    }
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


