//
//  XZSegmentedControlIndicatorView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/7/9.
//

#import "XZSegmentedControlIndicatorView.h"

@implementation XZSegmentedControlIndicatorView

+ (BOOL)supportsAnimatedTransition {
    return NO;
}

+ (void)segmentedControl:(id)segmentedControl prepareForLayoutAttributes:(id)indicatorLayoutAttributes {
    
}

@end


@implementation XZSegmentedControlIndicatorLayoutAttributes

@synthesize transiton = _transiton;

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
    new->_transiton = _transiton;
    new->_indicatorView = _indicatorView;
    return new;
}
@end
