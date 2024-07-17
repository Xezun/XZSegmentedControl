//
//  XZSegmentedControlSegment.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/7/15.
//

#import <UIKit/UIKit.h>
#import <XZSegmentedControl/XZSegmentedControlDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class XZSegmentedControl;
@interface XZSegmentedControlSegment : UICollectionViewCell

@property (nonatomic, weak, XZ_SEGMENTEDCONTROL_READONLY) XZSegmentedControl *segmentedControl;
/// 从未选中到选中的转场进度，值在 [0, 1] 之间。
/// @discussion 因为指示器的转场效果与目标 segment 相关，所以此属性与指示器的 transition 值不一定相同，
@property (nonatomic) CGFloat transition;

@end

NS_ASSUME_NONNULL_END
