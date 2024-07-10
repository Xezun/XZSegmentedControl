//
//  XZSegmentedControlIndicatorView.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XZSegmentedControl, XZSegmentedControlIndicatorLayoutAttributes;

/// 指示器视图基类
@interface XZSegmentedControlIndicatorView : UICollectionReusableView
/// 是否支持动态转场，默认否。
@property (class, nonatomic, readonly) BOOL supportsAnimatedTransition;
/// 由于在 `UICollectionReusableView` 的 `-preferredLayoutAttributesFittingAttributes:` 方法中，修改 `zIndex` 无效，所以定义了此方法。
+ (void)segmentedControl:(XZSegmentedControl *)segmentedControl prepareForLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)indicatorLayoutAttributes NS_SWIFT_NAME(segmentedControl(_:prepareForLayoutAttributes:));

@end


@interface XZSegmentedControlIndicatorLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic) CGFloat transiton;
/// 在仅修改 color 或 image 的情况下，不管是 invalidateIndicaotrLayout 还是 invalidateLayout 都无法重载视图，
/// 导致无法更新指示器样式，所以这里使用代理来解决这个问题。
/// 所以自定义视图，如果需要用到 color 或 image 必须在 `-applyLayoutAttributes:` 方法中，设置此属性为指示器视图。
@property (nonatomic, weak) XZSegmentedControlIndicatorView *indicatorView;
@end

NS_ASSUME_NONNULL_END
