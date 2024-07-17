//
//  XZSegmentedControlTextSegment.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlTextSegment.h"

@implementation XZSegmentedControlTextSegment {
    XZSegmentedControlTextLabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textLabel = [[XZSegmentedControlTextLabel alloc] initWithFrame:self.bounds];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 2;
        [self.contentView addSubview:_textLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    XZLog(@"segment(%@).setSelected: %@", self.text, selected ? @"true" : @"false");
    
    XZSegmentedControl *_segmentedControl = self.segmentedControl;
    if (selected) {
        _textLabel.textColor = _segmentedControl.selectedTitleColor;
        _textLabel.font      = _segmentedControl.selectedTitleFont;
    } else {
        _textLabel.textColor = _segmentedControl.titleColor;
        _textLabel.font      = _segmentedControl.titleFont;
    }
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (NSString *)text {
    return _textLabel.text;
}

- (void)setTransition:(CGFloat)transition {
    [super setTransition:transition];
    
    XZSegmentedControl *_segmentedControl = self.segmentedControl;
    XZLog(@"segment(%@, %ld).setTransition: %f", self.text, _segmentedControl.selectedIndex, transition);
    
    UIColor *titleColor = _segmentedControl.titleColor;
    UIColor *selectedTitleColor = _segmentedControl.selectedTitleColor;
    CGFloat r0, g0, b0, a0, r1, g1, b1, a1;
    [titleColor getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    [selectedTitleColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    _textLabel.textColor = [UIColor colorWithRed:r0 + (r1 - r0) * transition
                                           green:g0 + (g1 - g0) * transition
                                            blue:b0 + (b1 - b0) * transition
                                           alpha:a0 + (a1 - a0) * transition];
    
    UIFont *titleFont = _segmentedControl.titleFont;
    UIFont *selectedTitleFont = _segmentedControl.selectedTitleFont;
    
    if (titleFont.pointSize != selectedTitleFont.pointSize) {
        if ([titleFont.familyName isEqualToString:selectedTitleFont.familyName]) {
            CGFloat size = titleFont.pointSize + (selectedTitleFont.pointSize - titleFont.pointSize) * transition;
            _textLabel.font = [titleFont fontWithSize:size];
        }
    }
}

@end

@implementation XZSegmentedControlTextLabel

@end

@implementation XZSegmentedControlTextModel

@end
