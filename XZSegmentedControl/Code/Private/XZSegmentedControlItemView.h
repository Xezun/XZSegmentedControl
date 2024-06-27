//
//  XZSegmentedControlItemView.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <UIKit/UIKit.h>
#import <XZSegmentedControl/XZSegmentedControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlItemView : UICollectionViewCell
@property (nonatomic, strong) UIView<XZSegmentedControlItemView> *itemView;
@end

NS_ASSUME_NONNULL_END
