//
//  XZSegmentedControlIndicatorView.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlIndicatorView : UICollectionReusableView
@end

@interface XZSegmentedControlIndicatorLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIImage *image;
@end

NS_ASSUME_NONNULL_END
