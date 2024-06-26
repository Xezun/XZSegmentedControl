//
//  XZSegmentedControlTextView.h
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import <UIKit/UIKit.h>
#import <XZSegmentedControl/XZSegmentedControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZSegmentedControlTextView : UILabel <XZSegmentedControlItemView>
@property (nonatomic, unsafe_unretained, readonly) XZSegmentedControl *segmentedControl;
- (instancetype)initWithSegmentedControl:(XZSegmentedControl *)segmentedControl;
@end

NS_ASSUME_NONNULL_END
