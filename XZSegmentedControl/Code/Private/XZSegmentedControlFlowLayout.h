//
//  XZSegmentedControlFlowLayout.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <UIKit/UIKit.h>
#import <XZSegmentedControl/XZSegmentedControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlFlowLayout : UICollectionViewFlowLayout
@property (nonatomic) NSInteger selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong, nullable) UIImage *indicatorImage;
@property (nonatomic) CGSize indicatorSize;
@property (nonatomic) XZSegmentedControlIndicatorStyle indicatorStyle;
@end

NS_ASSUME_NONNULL_END
