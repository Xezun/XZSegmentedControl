//
//  XZSegmentedControlItemView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlItemView.h"

@implementation XZSegmentedControlItemView

- (void)setItemView:(UIView<XZSegmentedControlItemView> *)itemView {
    [_itemView removeFromSuperview];
    _itemView = itemView;
    if (_itemView != nil) {
        _itemView.frame = self.bounds;
        _itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_itemView];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if ([_itemView respondsToSelector:@selector(setHighlighted:)]) {
        [_itemView setHighlighted:highlighted];
    }
}

@end
