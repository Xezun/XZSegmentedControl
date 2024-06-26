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

@synthesize textLabel = _textLabel;

- (UILabel *)textLabelIfLoaded {
    return _textLabel;
}

- (UILabel *)textLabel {
    if (_textLabel != nil) {
        return _textLabel;
    }
    [self setTextLabel:[[UILabel alloc] init]];
    return _textLabel;
}

- (void)setTextLabel:(UILabel *)textLabel {
    if (_textLabel != textLabel) {
        [_textLabel removeFromSuperview];
        _textLabel = textLabel;
        if (_textLabel != nil) {
            _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:_textLabel];
            
            NSLayoutConstraint *const1 = [NSLayoutConstraint constraintWithItem:_textLabel attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0];
            NSLayoutConstraint *const2 = [NSLayoutConstraint constraintWithItem:_textLabel attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeCenterY) multiplier:1.0 constant:0];
            [self.contentView addConstraint:const1];
            [self.contentView addConstraint:const2];
        }
    }
}

@synthesize imageView = _imageView;

- (UIImageView *)imageViewIfLoaded {
    return _imageView;
}

- (UIImageView *)imageView {
    if (_imageView != nil) {
        return _imageView;
    }
    [self setImageView:[UIImageView new]];
    return _imageView;
}

- (void)setImageView:(UIImageView *)imageView {
    if (_imageView != imageView) {
        [_imageView removeFromSuperview];
        _imageView = imageView;
        
        if (_imageView != nil) {
            _imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:_imageView];
            
            NSLayoutConstraint *const1 = [NSLayoutConstraint constraintWithItem:_imageView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeCenterX) multiplier:1.0 constant:0];
            NSLayoutConstraint *const2 = [NSLayoutConstraint constraintWithItem:_imageView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self.contentView attribute:(NSLayoutAttributeCenterY) multiplier:1.0 constant:0];
            [self.contentView addConstraint:const1];
            [self.contentView addConstraint:const2];
        }
    }
}

@end
