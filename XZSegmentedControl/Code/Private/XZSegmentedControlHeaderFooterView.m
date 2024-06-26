//
//  XZSegmentedControlHeaderFooterView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlHeaderFooterView.h"

@implementation XZSegmentedControlHeaderFooterView

- (void)setItemView:(UIView<XZSegmentedControlItemView> *)itemView {
    [_itemView removeFromSuperview];
    _itemView = itemView;
    if (_itemView != nil) {
        _itemView.frame = self.bounds;
        _itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_itemView];
    }
}

@end
