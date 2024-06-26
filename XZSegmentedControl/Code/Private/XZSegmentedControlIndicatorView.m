//
//  XZSegmentedControlIndicatorView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlIndicatorView.h"

@implementation XZSegmentedControlIndicatorView {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = UIColor.blueColor;
    }
    return self;
}

- (void)applyLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)layoutAttributes {
    if (layoutAttributes.image) {
        self.backgroundColor = nil;
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:_imageView];
        }
        _imageView.image = layoutAttributes.image;
    } else if (layoutAttributes.color) {
        [_imageView removeFromSuperview];
        _imageView = nil;
        self.backgroundColor = layoutAttributes.color;
    } else {
        self.backgroundColor = UIColor.blueColor;
    }
}

- (void)willTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    NSLog(@"%@ ----- %@", oldLayout, newLayout);
}

- (void)didTransitionFromLayout:(UICollectionViewLayout *)oldLayout toLayout:(UICollectionViewLayout *)newLayout {
    NSLog(@"%@ ----- %@", oldLayout, newLayout);
}

@end

@implementation XZSegmentedControlIndicatorLayoutAttributes

- (void)setImage:(UIImage *)image {
    _image = image;
    _color = nil;
}

- (void)setColor:(UIColor *)color {
    _image = nil;
    _color = color;
}

@end
