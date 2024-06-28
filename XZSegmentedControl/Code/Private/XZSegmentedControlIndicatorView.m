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
- (instancetype)init {
    self = [super init];
    if (self) {
        _color = UIColor.blueColor;
    }
    return self;
}
@end
