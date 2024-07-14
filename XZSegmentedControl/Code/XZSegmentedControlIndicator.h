//
//  XZSegmentedControlIndicator.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/7/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XZSegmentedControl, XZSegmentedControlIndicatorLayoutAttributes;

/// 指示器视图基类
@interface XZSegmentedControlIndicator : UICollectionReusableView

/// 是否支持动态转场，默认否。
@property (class, nonatomic, readonly) BOOL supportsInteractiveTransition;

/// 子类应该在此方法中，根据 `selectedIndex` 计算指示器的布局。
/// @discussion
/// 如果指示器支持交互式转场，子类还可以通过 `selectedIndex + transition` 获得目标位置，并根据 `transition` 设置指示器的转场中间态布局。
/// @discussion
/// 子类还可以通过此方法修改 `zIndex` 改变指示器视图的层级位置。在 `-preferredLayoutAttributesFittingAttributes:` 方法中，修改 `zindex` 无效，必须在此方法中才可以。
+ (void)segmentedControl:(XZSegmentedControl *)segmentedControl prepareForLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributes NS_SWIFT_NAME(segmentedControl(_:prepareForLayoutAttributes:));

/// 非交互式的转场时，原生为指示器布局变化只有一个淡出淡入的过渡效果，所以组件提供此方法，为指示器应用新布局前，提供了一个自定义转场动画的机会。
/// @discussion
/// 此动画效果应用于，用户点击 segment 或方法 `-setSelectedIndex:animated:` 被调用时。
/// @discussion
/// 默认情况下，该方法默认仅执行了一个平移动画，代码如下。
/// @code
/// [UIView animateWithDuration:0.35 animations:^{
///     self.frame = layoutAttributes.frame;
/// }];
/// @endcode
/// @discussion
/// 一般情况下，子类重写此方法，不需要调用父类实现。
/// @param layoutAttributes 指示器布局信息。
- (void)animateTransition:(XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributes;

/// 在此方法中，设置了 layoutAttributes 的 indicatorView 属性为当前视图。
/// @param layoutAttributes 指示器布局信息。
- (void)applyLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributes NS_REQUIRES_SUPER;

@end

#if XZ_FRAMEWORK
#define XZ_SEGMENTEDCONTROL_READONLY
#else
#define XZ_SEGMENTEDCONTROL_READONLY readonly
#endif

@interface XZSegmentedControlIndicatorLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong, nullable, XZ_SEGMENTEDCONTROL_READONLY) UIColor *color;
@property (nonatomic, strong, nullable, XZ_SEGMENTEDCONTROL_READONLY) UIImage *image;
@property (nonatomic, XZ_SEGMENTEDCONTROL_READONLY) CGFloat transition;
/// 在未修改 UICollectionViewLayoutAttributes 的核心属性，例如 frame 或 size 的情况下，
/// 不管是 invalidateIndicaotrLayout 还是 invalidateLayout 都无法重载视图，导致无法应用
/// color 或 image 等样式，无法更新指示器，因此需要指示器视图在 `-applyLayoutAttributes:` 方法中填充此属性。
///
/// 在 -setSelectedIndex:animated: 方法中，无法直接添加动画，也需要此属性执行动画。
@property (nonatomic, weak, XZ_SEGMENTEDCONTROL_READONLY) XZSegmentedControlIndicator *indicatorView;
@end

NS_ASSUME_NONNULL_END
