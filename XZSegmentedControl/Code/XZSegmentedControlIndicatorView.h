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
@property (class, nonatomic, readonly) BOOL supportsInteractiveTransition;
/// 由于在 `UICollectionReusableView` 的 `-preferredLayoutAttributesFittingAttributes:` 方法中，修改 `zIndex` 无效，所以定义了此方法。
+ (void)segmentedControl:(XZSegmentedControl *)segmentedControl prepareForLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)indicatorLayoutAttributes NS_SWIFT_NAME(segmentedControl(_:prepareForLayoutAttributes:));
/// 子类须在此方法中，设置 indicatorLayoutAttributes 的 indicatorView 属性为当前视图。
/// - Parameter indicatorLayoutAttributes: 指示器的布局属性。
- (void)applyLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)indicatorLayoutAttributes;
@end


@interface XZSegmentedControlIndicatorLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong, nullable) UIColor *color;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic) CGFloat transiton;
/// 在未修改 UICollectionViewLayoutAttributes 的核心属性，例如 frame 或 size 的情况下，
/// 不管是 invalidateIndicaotrLayout 还是 invalidateLayout 都无法重载视图，导致无法应用
/// color 或 image 等样式，导致无法更新指示器，因此需要指示器视图在 `-applyLayoutAttributes:` 方法中填充此属性。
///
/// 在 -setSelectedIndex:animated: 方法中，无法直接添加动画，也需要此属性执行动画。
@property (nonatomic, weak) XZSegmentedControlIndicatorView *indicatorView;
@end

NS_ASSUME_NONNULL_END
