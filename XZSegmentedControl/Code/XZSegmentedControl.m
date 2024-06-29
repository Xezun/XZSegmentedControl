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
#import "XZSegmentedControlItemView.h"
#import "XZSegmentedControlTextItem.h"
#import "XZSegmentedControlTextView.h"

#define kReuseIdentifier @"reuseIdentifier"

@interface XZSegmentedControl () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    XZSegmentedControlFlowLayout *_flowLayout;
    UICollectionView *_collectionView;
    NSMutableArray<XZSegmentedControlTextItem *> *_titles;
    BOOL _needsUpdateTitles;
}

@end

@implementation XZSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame direction:(XZSegmentedControlDirection)direction {
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self __xz_didInitialize:direction];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame direction:(XZSegmentedControlDirectionHorizontal)];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self != nil) {
        [self __xz_didInitialize:XZSegmentedControlDirectionHorizontal];
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
    switch (_flowLayout.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal: {
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
        case UICollectionViewScrollDirectionVertical: {
            if (bounds.size.width != _flowLayout.itemSize.width) {
                _flowLayout.itemSize = CGSizeMake(bounds.size.width, _flowLayout.itemSize.height);
            }
            _headerView.frame = CGRectMake(0, 0, bounds.size.width, headerSize.height);
            _footerView.frame = CGRectMake(0, bounds.size.height - footerSize.height, bounds.size.width, footerSize.height);
            _collectionView.frame = CGRectMake(0, headerSize.height, bounds.size.width, bounds.size.height - headerSize.height - footerSize.height);
            break;
        }
        default:
            @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
            break;
    }
    
    [self __xz_setNeedsUpdateTitles];
    [self __xz_updateTitlesIfNeeded];
}

- (void)setIndicatorClass:(Class)indicatorClass {
    _flowLayout.indicatorClass = indicatorClass;
}

- (Class)indicatorClass {
    return _flowLayout.indicatorClass;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self setSelectedIndex:selectedIndex animated:animated focuses:YES];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated focuses:(BOOL)focuses {
    NSInteger const oldValue = _flowLayout.selectedIndex;
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForItem:oldValue inSection:0];
    XZSegmentedControlItemView *oldView = (id)[_collectionView cellForItemAtIndexPath:oldIndexPath];
    oldView.itemView.isSelected = NO;
    
    [_flowLayout setSelectedIndex:selectedIndex animated:animated];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
    XZSegmentedControlItemView *newView = (id)[_collectionView cellForItemAtIndexPath:newIndexPath];
    newView.itemView.isSelected = YES;
    
    if (focuses) {
        UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionNone;
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
        [_collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)reloadData {
    NSInteger const oldIndex = self.selectedIndex;
    NSInteger const count = [_dataSource numberOfItemsInSegmentedControl:self];
    
    NSInteger const newIndex = MAX(0, MIN(oldIndex, count - 1));
    [_collectionView reloadData];
    
    if (count > 0 && newIndex != oldIndex) {
        [self setSelectedIndex:newIndex animated:YES focuses:NO];
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    } else {
        
    }
}

- (void)insertItemAtIndex:(NSInteger)index {
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    
    NSInteger const _selectedIndex = self.selectedIndex;
    if (_selectedIndex >= index) {
        [self setSelectedIndex:_selectedIndex + 1 animated:true focuses:NO];
        [self sendActionsForControlEvents:(UIControlEventValueChanged)];
    }
}

- (void)removeItemAtIndex:(NSInteger)index {
    [_collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    NSInteger const _selectedIndex = self.selectedIndex;
    if (_selectedIndex >= index) {
        [self setSelectedIndex:_selectedIndex - 1 animated:true focuses:NO];
    }
}

- (UIView *)viewForItemAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    XZSegmentedControlItemView *cell = (id)[_collectionView cellForItemAtIndexPath:indexPath];
    return [cell itemView];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_dataSource) {
        return [_dataSource numberOfItemsInSegmentedControl:self];
    }
    return _titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZSegmentedControlItemView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReuseIdentifier forIndexPath:indexPath];

    NSInteger const index = indexPath.item;
    NSInteger const _selectedIndex = self.selectedIndex;
    if (_dataSource) {
        UIView<XZSegmentedControlItemView> *itemView = [_dataSource segmentedControl:self viewForItemAtIndex:index reusingView:cell.itemView];
        itemView.isSelected = (index == _selectedIndex);
        cell.itemView = itemView;
    } else if (_titles != nil) {
        XZSegmentedControlTextView *itemView = (id)cell.itemView;
        if (itemView == nil) {
            itemView = [[XZSegmentedControlTextView alloc] initWithSegmentedControl:self];
            cell.itemView = itemView;
        }
        itemView.isSelected = (index == _selectedIndex);
        itemView.text = _titles[index].text;
    }
    
    return cell;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return NO;
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setSelectedIndex:indexPath.item animated:YES focuses:YES];
    [self sendActionsForControlEvents:(UIControlEventValueChanged)];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataSource) {
        return [_dataSource segmentedControl:self sizeForItemAtIndex:indexPath.item];
    }
    if (_titles) {
        return _titles[indexPath.item].size;
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
            _collectionView.alwaysBounceVertical = YES;
            break;
            
        case XZSegmentedControlDirectionHorizontal:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            _collectionView.alwaysBounceHorizontal = YES;
            _collectionView.alwaysBounceVertical = NO;
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
    
    [self __xz_setNeedsUpdateTitles];
}


- (CGFloat)itemSpacing {
    return _flowLayout.minimumInteritemSpacing;
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    switch (_flowLayout.scrollDirection) {
        case UICollectionViewScrollDirectionHorizontal:
            _flowLayout.minimumLineSpacing = itemSpacing;
            _flowLayout.minimumInteritemSpacing = itemSpacing;
            break;
        case UICollectionViewScrollDirectionVertical:
            _flowLayout.minimumLineSpacing = itemSpacing;
            _flowLayout.minimumInteritemSpacing = itemSpacing;
            break;
        default:
            @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
            break;
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

- (NSArray<NSString *> *)titles {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:_titles.count];
    for (XZSegmentedControlTextItem *item in _titles) {
        [items addObject:item.text];
    }
    return items;
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    _dataSource = nil;
    
    if (titles.count == 0) {
        _titles = nil;
    } else if (_titles.count > titles.count) {
        [_titles removeObjectsInRange:NSMakeRange(titles.count, _titles.count - titles.count)];
    } else if (_titles.count < titles.count) {
        if (_titles == nil) {
            _titles = [NSMutableArray arrayWithCapacity:titles.count];
        }
        for (NSInteger i = _titles.count; i < titles.count; i++) {
            [_titles addObject:[[XZSegmentedControlTextItem alloc] init]];
        }
    }
    for (NSInteger i = 0; i < _titles.count; i++) {
        _titles[i].text = titles[i];
    }
    
    [self __xz_setNeedsUpdateTitles];
    [self __xz_updateTitlesIfNeeded];
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
        [self __xz_setNeedsUpdateTitles];
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
        [self __xz_setNeedsUpdateTitles];
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

- (void)__xz_didInitialize:(XZSegmentedControlDirection)direction {
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
    
    _flowLayout = [[XZSegmentedControlFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing      = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.sectionHeadersPinToVisibleBounds = NO;
    _flowLayout.sectionFootersPinToVisibleBounds = NO;
    _flowLayout.itemSize = CGSizeMake(1.0, 1.0);
    switch (direction) {
        case XZSegmentedControlDirectionHorizontal:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            break;
        case XZSegmentedControlDirectionVertical:
            _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            break;
        default:
            break;
    }

    _collectionView = [[XZSegmentedControlContentView alloc] initWithFrame:bounds collectionViewLayout:_flowLayout];
    _collectionView.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor                = [UIColor clearColor];
    _collectionView.prefetchingEnabled             = NO;
    _collectionView.allowsSelection                = YES;
    _collectionView.allowsMultipleSelection        = NO; // 不允许多选
    _collectionView.clipsToBounds                  = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator   = NO;
    _collectionView.alwaysBounceVertical           = NO;
    _collectionView.alwaysBounceHorizontal         = YES;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[XZSegmentedControlItemView class] forCellWithReuseIdentifier:kReuseIdentifier];
    _collectionView.delegate   = self;
    _collectionView.dataSource = self;
}

- (void)__xz_setNeedsUpdateTitles {
    if (_needsUpdateTitles || _titles.count == 0) {
        return;
    }
    _needsUpdateTitles = YES;
    [NSRunLoop.mainRunLoop performInModes:@[NSRunLoopCommonModes] block:^{
        [self __xz_updateTitlesIfNeeded];
        [self->_collectionView reloadData];
    }];
}

- (void)__xz_updateTitlesIfNeeded {
    if (!_needsUpdateTitles) return;
    _needsUpdateTitles = NO;
    
    CGRect const bounds = self.bounds;
    NSInteger const count = _titles.count;
    if (count == 0) {
        return;
    }
    switch (self.direction) {
        case XZSegmentedControlDirectionHorizontal:
            for (NSInteger i = 0; i < _titles.count; i++) {
                XZSegmentedControlTextItem *item = _titles[i];
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
            for (NSInteger i = 0; i < _titles.count; i++) {
                XZSegmentedControlTextItem *item = _titles[i];
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
