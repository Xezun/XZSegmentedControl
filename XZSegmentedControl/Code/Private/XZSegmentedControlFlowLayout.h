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
@property (nonatomic, weak, readonly) XZSegmentedControl *segmentedControl;
- (instancetype)initWithSegmentedControl:(XZSegmentedControl *)segmentedControl NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@property (nonatomic) NSInteger selectedIndex;
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@property (nonatomic, strong, nullable) UIColor *indicatorColor;
@property (nonatomic, strong, nullable) UIImage *indicatorImage;
@property (nonatomic) CGSize indicatorSize;
@property (nonatomic) CGFloat indicatorTransition;
@property (nonatomic) XZSegmentedControlIndicatorStyle indicatorStyle;
@property (nonatomic, nullable) Class indicatorClass;
@end

NS_ASSUME_NONNULL_END
