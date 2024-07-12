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
@property (nonatomic) id<UINavigationControllerDelegate> del;
/// 是否支持动态转场，默认否。
@property (class, nonatomic, readonly) BOOL supportsInteractiveTransition;

/// 由于在 `UICollectionReusableView` 的 `-preferredLayoutAttributesFittingAttributes:` 方法中，修改 `zIndex` 无效，所以定义了此方法。
+ (void)segmentedControl:(XZSegmentedControl *)segmentedControl prepareForLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributes NS_SWIFT_NAME(segmentedControl(_:prepareForLayoutAttributes:));

/// 当 layoutAttributes 变化时，原生不一定会为 DecorationView 添加上我们期望的动画效果，
/// 所以我们需要自行处理，方法 -setSelectedIndex:animated: 被调用时的动画效果。
///
/// 默认情况下，该方法默认仅执行了一个平移动画，代码如下。
/// @code
/// [UIView animateWithDuration:0.35 animations:^{
///     self.frame = layoutAttributes.frame;
/// }];
/// @endcode
///
/// 子类重写此方法，一般情况下，不需要调用父类实现。
///
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
@property (nonatomic, weak, XZ_SEGMENTEDCONTROL_READONLY) XZSegmentedControlIndicatorView *indicatorView;
@end

NS_ASSUME_NONNULL_END
