//
//  XZSegmentedControlIndicatorView.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <XZSegmentedControl/XZSegmentedControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlIndicatorView : UICollectionReusableView
@end

@interface XZSegmentedControlIndicatorLayoutAttributes ()
/// 在仅修改 color 或 image 的情况下，不管是 invalidateIndicaotrLayout 还是 invalidateLayout 都无法重载视图，
/// 导致无法更新指示器样式，所以这里使用代理来解决这个问题。
@property (nonatomic, weak) UICollectionReusableView *indicatorView;
@end

NS_ASSUME_NONNULL_END
