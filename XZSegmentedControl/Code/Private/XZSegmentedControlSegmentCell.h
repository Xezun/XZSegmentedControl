//
//  XZSegmentedControlSegmentCell.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <UIKit/UIKit.h>
#import <XZSegmentedControl/XZSegmentedControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlSegmentCell : UICollectionViewCell
@property (nonatomic, strong) UIView<XZSegmentedControlSegmentView> *segmentView;
@end

NS_ASSUME_NONNULL_END
