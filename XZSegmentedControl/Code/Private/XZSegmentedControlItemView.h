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
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *textLabelIfLoaded;
@property (nonatomic, strong, readonly) UIImageView *imageViewIfLoaded;
//@property (nonatomic, strong, readonly) UIImageView *backgroundView;
//@property (nonatomic, strong, readonly) UIImageView *selectedBackgroundView;
@end

NS_ASSUME_NONNULL_END
