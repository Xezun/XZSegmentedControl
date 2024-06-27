//
//  XZSegmentedControl.h
//  XZSegmentedControl
//
//  Created by M. X. Z. on 2016/10/7.
//  Copyright © 2016年 mlibai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UITableView, UISegmentedControl;

typedef NS_ENUM(NSUInteger, XZSegmentedControlDirection) {
    XZSegmentedControlDirectionVertical = 0,
    XZSegmentedControlDirectionHorizontal = 1
};

/// 指示器样式。
typedef NS_ENUM(NSUInteger, XZSegmentedControlIndicatorStyle) {
    /// 矩形色块指示器：横向滚动时，指示器在 item 底部；纵向滚动时，指示器在 item 右侧。
    XZSegmentedControlIndicatorStyle1,
    /// 矩形色块指示器：横向滚动时，指示器在 item 顶部；纵向滚动时，指示器在 item 左侧。
    XZSegmentedControlIndicatorStyle2,
};

/// 使用自定义视图作为 item 时，应遵循的协议。
@protocol XZSegmentedControlItemView <NSObject>
@property (nonatomic, setter=setSelected:) BOOL isSelected;
@optional
@property (nonatomic, setter=setHighlighted:) BOOL isHighlighted;
@end

@protocol XZSegmentedControlDataSource;

@interface XZSegmentedControl : UIControl

/// 指示器方向。支持在 IB 中设置，使用 0 表示纵向，使用 1 表示横向。
#if TARGET_INTERFACE_BUILDER
@property (nonatomic) IBInspectable NSInteger direction;
#else
@property (nonatomic) XZSegmentedControlDirection direction;
#endif

- (instancetype)initWithFrame:(CGRect)frame direction:(XZSegmentedControlDirection)direction NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

/// 横向时，展示在左侧的视图；纵向时，展示在顶部的视图。
@property (nonatomic, strong, nullable) __kindof UIView *headerView;
/// 横向时，展示在右侧的视图；纵向时，展示在底部的视图。
@property (nonatomic, strong, nullable) __kindof UIView *footerView;

/// item 的大小。优先使用代理方法返回的大小。
/// @discussion 使用 titles 时 item 的大小会根据字体自动计算，此属性将作为最小值使用。
@property (nonatomic) CGSize itemSize;
/// item 间距。
@property (nonatomic) CGFloat itemSpacing;

/// 使用色块作为指示器，设置此属性，会清除 indicatorImage 的设置。
@property (nonatomic, strong, nullable) UIColor *indicatorColor;
/// 使用图片作为指示器，图片的大小受 indicatorSize 属性影响。
@property (nonatomic, strong, nullable) UIImage *indicatorImage;
/// 指定长宽，若为零，则使用默认值。
/// @li 横向滚动时，宽度默认为 item 的宽度，高度为 3.0 点。
/// @li 纵向滚动时，高度默认为 item 的高度，宽度为 3.0 点。
/// @li 正数表示使用值，负数表示与默认值的差。
@property (nonatomic) CGSize indicatorSize;
/// 指示器样式。
@property (nonatomic) XZSegmentedControlIndicatorStyle indicatorStyle;

@property (nonatomic, readonly) NSInteger numberOfSegments;

@property (nonatomic) NSInteger selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

@property (nonatomic, weak) id<XZSegmentedControlDataSource> dataSource;

/// 当使用数据源时，必须使用此方法更新视图。
- (void)reloadData;
- (void)insertItemAtIndex:(NSInteger)index;
- (void)removeItemAtIndex:(NSInteger)index;

- (__kindof UIView *)viewForItemAtIndex:(NSInteger)index;

/// 使用 item 标题文本作为数据源。
/// @note 设置此属性，将取消 dataSource 的设置。
/// @note 每个 item 的宽度，将根据字体自动计算，同时受 itemSize 属性约束。
@property (nonatomic, copy, nullable) NSArray<NSString *> *titles;

/// 普通 item 文本颜色。该属性仅在使用 titles 时生效。
@property (nonatomic, strong, null_resettable) UIColor *titleColor;
/// 被选择的 item 的文本颜色。该属性仅在使用 titles 时生效。
@property (nonatomic, strong, null_resettable) UIColor *selectedTitleColor;
/// 普通 item 文本字体。该属性仅在使用 titles 时生效。
@property (nonatomic, strong, null_resettable) UIFont  *titleFont;
/// 被选中的 item 文本字体。该属性仅在使用 titles 时生效。
@property (nonatomic, strong, null_resettable) UIFont  *selectedTitleFont;

@end


/// 使用自定义视图时的数据源协议。
@protocol XZSegmentedControlDataSource <NSObject>
/// 获取 item 的数量。
/// - Parameter segmentedControl: 调用此方法的对象
- (NSInteger)numberOfItemsInSegmentedControl:(XZSegmentedControl *)segmentedControl;
/// 数据源应在此方法中返回 item 的自定义视图。
/// - Parameters:
///   - segmentedControl: 调用此方法的对象
///   - index: item 的位置索引
///   - reusingView: 可供重用的视图
- (__kindof UIView<XZSegmentedControlItemView> *)segmentedControl:(XZSegmentedControl *)segmentedControl viewForItemAtIndex:(NSInteger)index reusingView:(nullable __kindof UIView<XZSegmentedControlItemView> *)reusingView;
/// 返回 item 的大小。
/// - Parameters:
///   - segmentedControl: 调用此方法的对象
///   - index: item 的位置索引
- (CGSize)segmentedControl:(XZSegmentedControl *)segmentedControl sizeForItemAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
