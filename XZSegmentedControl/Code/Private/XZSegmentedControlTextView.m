//
//  XZSegmentedControlTextView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlTextView.h"

@implementation XZSegmentedControlTextView
- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:NSGenericException reason:nil userInfo:nil];
}
- (instancetype)initWithSegmentedControl:(XZSegmentedControl *)segmentedControl {
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        _segmentedControl  = segmentedControl;
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor     = segmentedControl.titleColor;
        self.font          = segmentedControl.titleFont;
        self.numberOfLines = 2;
    }
    return self;
}

@synthesize isSelected = _isSelected;

- (void)setSelected:(BOOL)isSelected {
    if (_isSelected != isSelected) {
        _isSelected = isSelected;
        if (_isSelected) {
            self.textColor = _segmentedControl.selectedTitleColor;
            self.font      = _segmentedControl.selectedTitleFont;
        } else {
            self.textColor = _segmentedControl.titleColor;
            self.font      = _segmentedControl.titleFont;
        }
    }
}
@end
