//
//  XZSegmentedControlSegmentCell.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlSegmentCell.h"

@implementation XZSegmentedControlSegmentCell

- (void)setSegmentView:(UIView<XZSegmentedControlSegmentView> *)segmentView {
    [_segmentView removeFromSuperview];
    _segmentView = segmentView;
    if (_segmentView != nil) {
        _segmentView.frame = self.bounds;
        _segmentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_segmentView];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if ([_segmentView respondsToSelector:@selector(setHighlighted:)]) {
        [_segmentView setHighlighted:highlighted];
    }
}

@end
