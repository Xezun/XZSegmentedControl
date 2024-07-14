//
//  XZSegmentedControlTextSegmentView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlTextSegmentView.h"

@implementation XZSegmentedControlTextSegmentView {
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

@end

@implementation XZSegmentedControlTextLabel

@end

@implementation XZSegmentedControlTextModel

@end
