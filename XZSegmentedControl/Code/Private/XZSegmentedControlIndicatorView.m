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
    // 在 -preferredLayoutAttributesFittingAttributes: 方法设置代理无效。
    // 可能的原因是这个方法参数是复制份，而不是原份。
    layoutAttributes.indicatorView = self;
    
    if (layoutAttributes.image) {
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
            _imageView.contentMode = UIViewContentModeScaleAspectFit;
            _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addSubview:_imageView];
        }
        _imageView.image = layoutAttributes.image;
    } else {
        [_imageView removeFromSuperview];
        _imageView = nil;
    }
    
    self.backgroundColor = layoutAttributes.color;
}

@end




@implementation XZSegmentedControlIndicatorLayoutAttributes

@synthesize indicatorTransiton = _indicatorTransiton;
@synthesize indicatorTransitonRect = _indicatorTransitonRect;

- (instancetype)init {
    self = [super init];
    if (self) {
        _color = UIColor.blueColor;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        [_indicatorView applyLayoutAttributes:self];
    }
}

- (void)setColor:(UIColor *)color {
    if (_color != color) {
        _color = color;
        [_indicatorView applyLayoutAttributes:self];
    }
}

- (id)copyWithZone:(NSZone *)zone {
    XZSegmentedControlIndicatorLayoutAttributes *new = [super copyWithZone:zone];
    new->_image = _image;
    new->_color = _color;
    new->_indicatorView = _indicatorView;
    return new;
}
@end
