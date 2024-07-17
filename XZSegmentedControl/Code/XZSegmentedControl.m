//
//  XZSegmentedControl.m
//  XZSegmentedControl
//
//  Created by M. X. Z. on 2016/10/7.
//  Copyright © 2016年 mlibai. All rights reserved.
//

#import "XZSegmentedControl.h"
#import "XZSegmentedControlContentView.h"
#import "XZSegmentedControlFlowLayout.h"
#import "XZSegmentedControlTextSegment.h"

#define kReuseIdentifier @"XZSegmentedControlReuseIdentifier"

@interface XZSegmentedControl () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    XZSegmentedControlFlowLayout *_flowLayout;
    UICollectionView             *_collectionView;
    NSMutableArray<XZSegmentedControlTextModel *> *_titleModels;
    BOOL _needsUpdateTitleModels;
    XZSegmentedControlSegment * __weak _transitionSegment;
}

@end

@implementation XZSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame direction:(XZSegmentedControlDirection)direction {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self XZ_didInitialize:direction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame direction:(XZSegmentedControlDirectionHorizontal)];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self != nil) {
        [self XZ_didInitialize:XZSegmentedControlDirectionHorizontal];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect const bounds = self.bounds;
    CGSize const headerSize = _headerView.frame.size;
    CGSize const footerSize = _footerView.frame.size;
    
    // 横向滚动时，自动将元素高度设置为自身高度
    // 纵向滚动时，自动将元素宽度设置为自身宽度
    switch (self.direction) {
        case XZSegmentedControlDirectionHorizontal: {
            if (bounds.size.height != _flowLayout.itemSize.height) {
                _flowLayout.itemSize = CGSizeMake(_flowLayout.itemSize.width, bounds.size.height);
            }
            
            switch (self.effectiveUserInterfaceLayoutDirection) {
                case UIUserInterfaceLayoutDirectionLeftToRight:
                    _headerView.frame = CGRectMake(0, 0, headerSize.width, bounds.size.height);
                    _footerView.frame = CGRectMake(bounds.size.width - footerSize.width, 0, footerSize.width, bounds.size.height);
                    _collectionView.frame = CGRectMake(headerSize.width, 0, bounds.size.width - headerSize.width - footerSize.width, bounds.size.height);
                    break;
                case UIUserInterfaceLayoutDirectionRightToLeft:
                    _headerView.frame = CGRectMake(bounds.size.width - headerSize.width, 0, headerSize.width, bounds.size.height);
                    _footerView.frame = CGRectMake(0, 0, footerSize.width, bounds.size.height);
                    _collectionView.frame = CGRectMake(footerSize.width, 0, bounds.size.width - headerSize.width - footerSize.width, bounds.size.height);
                    break;
                default:
                    break;
            }
            break;
        }
        case XZSegmentedControlDirectionVertical: {
            if (bounds.size.width != _flowLayout.itemSize.width) {
                _flowLayout.itemSize = CGSizeMake(bounds.size.width, _flowLayout.itemSize.height);
            }
            _headerView.frame = CGRectMake(0, 0, bounds.size.width, headerSize.height);
            _footerView.frame = CGRectMake(0, bounds.size.height - footerSize.height, bounds.size.width, footerSize.height);
            _collectionView.frame = CGRectMake(0, headerSize.height, bounds.size.width, bounds.size.height - headerSize.height - footerSize.height);
            break;
        }
        default: {
            break;
        }
    }
    
    [self XZ_setNeedsUpdateTitleModels];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self setSelectedIndex:selectedIndex animated:animated centered:YES];
}

- (void)setSelectedIndex:(NSInteger const)selectedIndex animated:(BOOL)animated centered:(BOOL)centered {
    NSInteger const oldValue = _flowLayout.selectedIndex;
    if (selectedIndex == oldValue) return;
    
    // 取消已选
    if (oldValue != NSNotFound) {
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:oldValue inSection:0];
        [_collectionView deselectItemAtIndexPath:oldIndexPath animated:animated];
    }
    
    // 移动指示器位置
    [_flowLayout setSelectedIndex:selectedIndex animated:animated];
    
    // 选中新的
    UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionNone;
    if (centered) {
        switch (_flowLayout.scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal:
                scrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
                break;
            case UICollectionViewScrollDirectionVertical:
                scrollPosition = UICollectionViewScrollPositionCenteredVertically;
                break;
            default:
                break;
        }
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:scrollPosition animated:YES];
}

- (void)reloadData {
    [_collectionView reloadData];
    
    // TODO: 测试 reloadData 之后，selectedIndex 的值是否立即改变了。
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.selectedIndex inSection:0];
    switch (self.direction) {
        case XZSegmentedControlDirectionVertical:
            [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredVertically)];
            break;
        case XZSegmentedControlDirectionHorizontal:
            [_collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
            break;
        default:
            break;
    }
}

- (void)insertSegmentAtIndex:(NSInteger)index {
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    
    NSInteger const selectedIndex = self.selectedIndex;
    if (selectedIndex >= index) {
        [_flowLayout setSelectedIndex:selectedIndex + 1 animated:YES];
    }
}

- (void)removeSegmentAtIndex:(NSInteger)index {
    [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    NSInteger const selectedIndex = self.selectedIndex;
    if (selectedIndex >= index) {
        [_flowLayout setSelectedIndex:selectedIndex - 1 animated:YES];
    }
}

- (__kindof XZSegmentedControlSegment *)segmentForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return (XZSegmentedControlSegment *)[_collectionView cellForItemAtIndexPath:indexPath];
}

- (XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributesForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return (id)[_collectionView layoutAttributesForItemAtIndexPath:indexPath];
}

- (void)registerClass:(Class)segmentClass forSegmentWithReuseIdentifier:(NSString *)identifier {
    NSParameterAssert([segmentClass isSubclassOfClass:[XZSegmentedControlSegment class]]);
    NSParameterAssert(![identifier isEqualToString:kReuseIdentifier]);
    [_collectionView registerClass:segmentClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(UINib *)segmentNib forSegmentWithReuseIdentifier:(NSString *)identifier {
    NSParameterAssert(![identifier isEqualToString:kReuseIdentifier]);
    [_collectionView registerNib:segmentNib forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableSegmentWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    return [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataSource) {
        return [_dataSource numberOfSegmentsInSegmentedControl:self];
    }
    return _titleModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger const index = indexPath.item;
    
    if (_dataSource) {
        XZSegmentedControlSegment *segment = [_dataSource segmentedControl:self segmentForItemAtIndex:index];
        segment.segmentedControl = self;
        return segment;
    }
    
    XZSegmentedControlTextSegment *segment = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];
    segment.segmentedControl = self;
    
    NSInteger const selectedIndex = self.selectedIndex;
    XZSegmentedControlTextModel *model = _titleModels[index];
    segment.text       = model.text;
    segment.transition = (index == selectedIndex ? 1.0 : 0);
    
    return segment;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_flowLayout setSelectedIndex:indexPath.item animated:YES];
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource) {
        return [_dataSource segmentedControl:self sizeForSegmentAtIndex:indexPath.item];
    }
    if (_titleModels) {
        return _titleModels[indexPath.item].size;
    }
    return collectionViewLayout.itemSize;
}

#pragma mark - 属性

- (NSInteger)numberOfSegments {
    return [_collectionView numberOfItemsInSection:0];
}

- (XZSegmentedControlDirection)direction {
    switch (_flowLayout.scrollDirection) {
        case UICollectionViewScrollDirectionVertical:
            return XZSegmentedControlDirectionVertical;
            
        case UICollectionViewScrollDirectionHorizontal:
            return XZSegmentedControlDirectionHorizontal;
            
        default:
            @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
    }
}

- (void)setDirection:(XZSegmentedControlDirection)direction {
    switch (direction) {
        case XZSegmentedControlDirectionVertical:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            _collectionView.alwaysBounceHorizontal = NO;
            _collectionView.alwaysBounceVertical   = YES;
            break;
            
        case XZSegmentedControlDirectionHorizontal:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _collectionView.alwaysBounceHorizontal = YES;
            _collectionView.alwaysBounceVertical   = NO;
            break;
            
        default:
            @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
    }
    
}

- (void)setHeaderView:(UIView *)headerView {
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        _headerView = headerView;
        if (_headerView != nil) {
            if (CGRectIsEmpty(_headerView.frame)) {
                [_headerView sizeToFit];
            }
            [self addSubview:_headerView];
        }
    }
}

- (void)setFooterView:(UIView *)footerView {
    if (_footerView != footerView) {
        [_footerView removeFromSuperview];
        _footerView = footerView;
        if (_footerView != nil) {
            if (CGRectIsEmpty(_footerView.frame)) {
                [_footerView sizeToFit];
            }
            [self addSubview:_footerView];
        }
    }
}

- (NSInteger)selectedIndex {
    return _flowLayout.selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (CGSize)itemSize {
    return _flowLayout.itemSize;
}

- (void)setItemSize:(CGSize)itemSize {
    _flowLayout.itemSize = itemSize;
    
    [self XZ_setNeedsUpdateTitleModels];
}


- (CGFloat)interitemSpacing {
    return _flowLayout.minimumInteritemSpacing;
}

- (void)setInteritemSpacing:(CGFloat)interitemSpacing {
    switch (_flowLayout.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            _flowLayout.minimumLineSpacing = interitemSpacing;
            _flowLayout.minimumInteritemSpacing = interitemSpacing;
            break;
        case UICollectionViewScrollDirectionVertical:
            _flowLayout.minimumLineSpacing = interitemSpacing;
            _flowLayout.minimumInteritemSpacing = interitemSpacing;
            break;
        default:
            @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
            break;
    }
}

- (CGFloat)transition {
    return _flowLayout.indicatorTransition;
}

- (void)setTransition:(CGFloat)indicatorTransition {
    _flowLayout.indicatorTransition = indicatorTransition;
    
    NSInteger                   const selectedIndex        = _flowLayout.selectedIndex;
    XZSegmentedControlSegment * const selectedSegment      = [self segmentForItemAtIndex:selectedIndex];
    XZSegmentedControlSegment * const oldTransitionSegment = _transitionSegment;
    
    if (indicatorTransition > 0) {
        CGFloat const intPart = floor(indicatorTransition);
        CGFloat const decPart = indicatorTransition - intPart;
        
        selectedSegment.transition = 1.0 - decPart;
        
        NSInteger const count = [_collectionView numberOfItemsInSection:0];
        NSInteger const transitionIndex = selectedIndex + intPart + 1;
        if (transitionIndex <= count - 1) {
            XZSegmentedControlSegment * const newTransitionSegment = [self segmentForItemAtIndex:transitionIndex];
            if (oldTransitionSegment !=  newTransitionSegment) {
                oldTransitionSegment.transition = 0;
                _transitionSegment =  newTransitionSegment;
            }
            _transitionSegment.transition = decPart;
        } else if (oldTransitionSegment != nil) {
            oldTransitionSegment.transition = 0;
            _transitionSegment = nil;
        }
    } else if (indicatorTransition < 0) {
        CGFloat const intPart = ceil(indicatorTransition);
        CGFloat const decPart = indicatorTransition - intPart;
        
        selectedSegment.transition = 1.0 + decPart;
        
        NSInteger const transitionIndex = selectedIndex + intPart - 1;
        if (transitionIndex >= 0) {
            XZSegmentedControlSegment * const newTransitionSegment = [self segmentForItemAtIndex:transitionIndex];
            if (oldTransitionSegment != newTransitionSegment) {
                oldTransitionSegment.transition = 0;
                _transitionSegment = newTransitionSegment;
            }
            _transitionSegment.transition = -decPart;
        } else if (oldTransitionSegment != nil) {
            oldTransitionSegment.transition = 0;
            _transitionSegment = nil;
        }
    } else {
        if (oldTransitionSegment != nil) {
            oldTransitionSegment.transition = 0;
            _transitionSegment = nil;
        }
        selectedSegment.transition = 1.0;
    }
}

- (UIColor *)indicatorColor {
    return _flowLayout.indicatorColor;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _flowLayout.indicatorColor = indicatorColor;
}

- (UIImage *)indicatorImage {
    return _flowLayout.indicatorImage;
}

- (void)setIndicatorImage:(UIImage *)indicatorImage {
    _flowLayout.indicatorImage = indicatorImage;
}

- (CGSize)indicatorSize {
    return _flowLayout.indicatorSize;
}

- (void)setIndicatorSize:(CGSize)indicatorSize {
    _flowLayout.indicatorSize = indicatorSize;
}

- (XZSegmentedControlIndicatorStyle)indicatorStyle {
    return _flowLayout.indicatorStyle;
}

- (void)setIndicatorStyle:(XZSegmentedControlIndicatorStyle)indicatorStyle {
    _flowLayout.indicatorStyle = indicatorStyle;
}

- (void)setIndicatorClass:(Class)indicatorClass {
    _flowLayout.indicatorClass = indicatorClass;
}

- (Class)indicatorClass {
    return _flowLayout.indicatorClass;
}

- (void)setDataSource:(id<XZSegmentedControlDataSource>)dataSource {
    _titleModels = nil;
    _dataSource = dataSource;
    [self reloadData];
}

- (NSArray<NSString *> *)titles {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:_titleModels.count];
    for (XZSegmentedControlTextModel *item in _titleModels) {
        [items addObject:item.text];
    }
    return items;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _dataSource = nil;
    if (titles.count == 0) {
        _titleModels = nil;
    } else if (titles.count < _titleModels.count) {
        [_titleModels removeObjectsInRange:NSMakeRange(titles.count, _titleModels.count - titles.count)];
    } else if (titles.count > _titleModels.count) {
        if (_titleModels == nil) {
            _titleModels = [NSMutableArray arrayWithCapacity:titles.count];
        }
        for (NSInteger i = _titleModels.count; i < titles.count; i++) {
            [_titleModels addObject:[[XZSegmentedControlTextModel alloc] init]];
        }
    }
    for (NSInteger i = 0; i < _titleModels.count; i++) {
        _titleModels[i].text = titles[i];
    }
    [self XZ_setNeedsUpdateTitleModels];
    [self XZ_updateTitleModelsIfNeeded];
    [self reloadData];
}

@synthesize titleFont = _titleFont;

- (UIFont *)titleFont {
    if (_titleFont != nil) {
        return _titleFont;
    }
    return [UIFont systemFontOfSize:17.0];
}

- (void)setTitleFont:(UIFont *)titleFont {
    if (_titleFont != titleFont) {
        _titleFont = titleFont;
        [self XZ_setNeedsUpdateTitleModels];
    }
}

@synthesize selectedTitleFont = _selectedTitleFont;

- (UIFont *)selectedTitleFont {
    if (_selectedTitleFont != nil) {
        return _selectedTitleFont;
    }
    if (_titleFont != nil) {
        return _titleFont;
    }
    return [UIFont boldSystemFontOfSize:17.0];
}

- (void)setSelectedTitleFont:(UIFont *)selectedTitleFont {
    if (_selectedTitleFont != selectedTitleFont) {
        _selectedTitleFont = selectedTitleFont;
        [self XZ_setNeedsUpdateTitleModels];
    }
}

- (UIColor *)titleColor {
    if (_titleColor != nil) {
        return _titleColor;
    }
    return UIColor.blackColor;
}

- (UIColor *)selectedTitleColor {
    if (_selectedTitleColor != nil) {
        return _selectedTitleColor;
    }
    return UIColor.blueColor;
}

#pragma mark - Private Methods

- (void)XZ_didInitialize:(XZSegmentedControlDirection)direction {
    self.clipsToBounds = YES;
    
    CGRect const bounds = self.bounds;
    
    _titleFont = [UIFont systemFontOfSize:17.0];
    _selectedTitleFont = [UIFont boldSystemFontOfSize:17.0];
    _titleColor = UIColor.blackColor;
    if (@available(iOS 15.0, *)) {
        _selectedTitleColor = UIColor.tintColor;
    } else {
        _selectedTitleColor = UIColor.blueColor;
    }
    
    _flowLayout = [[XZSegmentedControlFlowLayout alloc] initWithSegmentedControl:self];
    _flowLayout.minimumLineSpacing      = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.sectionHeadersPinToVisibleBounds = NO;
    _flowLayout.sectionFootersPinToVisibleBounds = NO;
    _flowLayout.itemSize = CGSizeMake(1.0, 1.0);

    _collectionView = [[XZSegmentedControlContentView alloc] initWithFrame:bounds collectionViewLayout:_flowLayout];
    _collectionView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor                = [UIColor clearColor];
    _collectionView.prefetchingEnabled             = NO;
    _collectionView.allowsSelection                = YES;
    _collectionView.allowsMultipleSelection        = NO; // 不允许多选
    _collectionView.clipsToBounds                  = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator   = NO;
    [self addSubview:_collectionView];
    
    switch (direction) {
        case XZSegmentedControlDirectionHorizontal:
            _flowLayout.scrollDirection             = UICollectionViewScrollDirectionHorizontal;
            _collectionView.alwaysBounceVertical    = NO;
            _collectionView.alwaysBounceHorizontal  = YES;
            break;
        case XZSegmentedControlDirectionVertical:
            _flowLayout.scrollDirection             = UICollectionViewScrollDirectionVertical;
            _collectionView.alwaysBounceVertical    = YES;
            _collectionView.alwaysBounceHorizontal  = NO;
            break;
        default:
            break;
    }
    
    [_collectionView registerClass:[XZSegmentedControlTextSegment class] forCellWithReuseIdentifier:kReuseIdentifier];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
}

- (void)XZ_setNeedsUpdateTitleModels {
    if (_needsUpdateTitleModels || _titleModels.count == 0) {
        return;
    }
    _needsUpdateTitleModels = YES;
    [NSRunLoop.mainRunLoop performInModes:@[NSRunLoopCommonModes] block:^{
        [self XZ_updateTitleModelsIfNeeded];
        [self->_collectionView reloadData];
    }];
}

- (void)XZ_updateTitleModelsIfNeeded {
    if (!_needsUpdateTitleModels) return;
    _needsUpdateTitleModels = NO;
    
    CGRect const bounds = self.bounds;
    NSInteger const count = _titleModels.count;
    if (count == 0) {
        return;
    }
    switch (self.direction) {
        case XZSegmentedControlDirectionHorizontal:
            for (NSInteger i = 0; i < _titleModels.count; i++) {
                XZSegmentedControlTextModel *item = _titleModels[i];
                CGSize                 const size    = CGSizeMake(0, bounds.size.height);
                NSStringDrawingOptions const options = NSStringDrawingUsesLineFragmentOrigin;
                CGFloat const width1 = [item.text boundingRectWithSize:size options:options attributes:@{
                    NSFontAttributeName: self.titleFont
                } context:nil].size.width;
                CGFloat const width2 = [item.text boundingRectWithSize:size options:options attributes:@{
                    NSFontAttributeName: self.selectedTitleFont
                } context:nil].size.width;
                item.size = CGSizeMake(MAX(ceil(MAX(width1, width2)) + 10.0, self.itemSize.width), bounds.size.height);
            }
            break;
        case XZSegmentedControlDirectionVertical:
            for (NSInteger i = 0; i < _titleModels.count; i++) {
                XZSegmentedControlTextModel *item = _titleModels[i];
                CGSize                 const size    = CGSizeMake(bounds.size.width, 0);
                NSStringDrawingOptions const options = NSStringDrawingUsesLineFragmentOrigin;
                CGFloat const height1 = [item.text boundingRectWithSize:size options:options attributes:@{
                    NSFontAttributeName: self.titleFont
                } context:nil].size.height;
                CGFloat const height2 = [item.text boundingRectWithSize:size options:options attributes:@{
                    NSFontAttributeName: self.selectedTitleFont
                } context:nil].size.height;
                item.size = CGSizeMake(bounds.size.width, MAX(ceil(MAX(height1, height2)) + 10.0, self.itemSize.height));
            }
            break;
        default:
            break;
    }
}

@end
