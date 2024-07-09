//
//  XZSegmentedControlLineIndicatorView.m
//  XZSegmentedControl
//
//  Created by 徐臻 on 2024/6/25.
//

#import "XZSegmentedControlLineIndicatorView.h"

#define kIndicatorWidth 3.0

@implementation XZSegmentedControlLineIndicatorView {
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        self.backgroundColor = UIColor.blueColor;
    }
    return self;
}

+ (CGRect)segmentedControl:(XZSegmentedControl *)segmentedControl frameForIndicatorAtIndex:(NSInteger)selectedIndex {
    return CGRectZero;
}

+ (void)segmentedControl:(XZSegmentedControl *)segmentedControl prepareForLayoutAttributes:(XZSegmentedControlIndicatorLayoutAttributes *)indicatorLayoutAttributes {
    CGFloat   const transition    = indicatorLayoutAttributes.transiton;
    NSInteger const count         = segmentedControl.numberOfSegments;
    NSInteger const selectedIndex = segmentedControl.selectedIndex;
    
    indicatorLayoutAttributes.frame = [self segmentedControl:segmentedControl frameForIndicatorAtIndex:selectedIndex];
    
    CGRect to = CGRectZero;
    if (transition > 0) {
        NSInteger newIndex = MIN(count - 1, ceil(selectedIndex + transition));
        to = [self segmentedControl:segmentedControl frameForIndicatorAtIndex:newIndex];
    } else if (transition < 0) {
        NSInteger newIndex = MAX(0, floor(selectedIndex + transition));
        to = [self segmentedControl:segmentedControl frameForIndicatorAtIndex:newIndex];
    } else {
        return;
    }
    
    CGRect from = indicatorLayoutAttributes.frame;
    
    CGFloat percent = ABS(transition) / ceil(ABS(transition));
    
    // NSLog(@"from: %@, to: %@, transition: %f, percent: %f", NSStringFromCGRect(from), NSStringFromCGRect(to), transition, percent);
    
    CGFloat x = from.origin.x + (to.origin.x - from.origin.x) * percent;
    CGFloat y = from.origin.y + (to.origin.y - from.origin.y) * percent;
    CGFloat w = from.size.width + (to.size.width - from.size.width) * percent;
    CGFloat h = from.size.height + (to.size.height - to.size.height) * percent;
    indicatorLayoutAttributes.frame = CGRectMake(x, y, w, h);
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

@implementation XZSegmentedControlMarkLineIndicatorView

+ (CGRect)segmentedControl:(XZSegmentedControl *)segmentedControl frameForIndicatorAtIndex:(NSInteger)selectedIndex {
    CGRect const frame = [segmentedControl frameForSegmentAtIndex:selectedIndex];
    CGSize const indicatorSize = segmentedControl.indicatorSize;
    switch (segmentedControl.direction) {
        case XZSegmentedControlDirectionHorizontal: {
            CGFloat const h = indicatorSize.height > 0 ? indicatorSize.height : kIndicatorWidth;
            CGFloat const w = indicatorSize.width > 0 ? indicatorSize.width : (indicatorSize.width + frame.size.width);
            CGFloat const x = frame.origin.x + (frame.size.width - w) * 0.5;
            CGFloat const y = CGRectGetMaxY(frame) - h;
            return CGRectMake(x, y, w, h);
            break;
        }
        case XZSegmentedControlDirectionVertical: {
            CGFloat const w = indicatorSize.width > 0 ? indicatorSize.width : kIndicatorWidth;
            CGFloat const h = indicatorSize.height > 0 ? indicatorSize.height : (indicatorSize.height + frame.size.height);
            CGFloat const y = frame.origin.y + (frame.size.height - h) * 0.5;
            CGFloat const x = CGRectGetMaxX(frame) - w;
            return CGRectMake(x, y, w, h);
            break;
        }
        default:
            return CGRectZero;
            break;
    }
}

@end

@implementation XZSegmentedControlNoteLineIndicatorView

+ (CGRect)segmentedControl:(XZSegmentedControl *)segmentedControl frameForIndicatorAtIndex:(NSInteger)selectedIndex {
    CGRect const frame = [segmentedControl frameForSegmentAtIndex:selectedIndex];
    CGSize const indicatorSize = segmentedControl.indicatorSize;
    switch (segmentedControl.direction) {
        case UICollectionViewScrollDirectionHorizontal: {
            CGFloat const h = indicatorSize.height > 0 ? indicatorSize.height : kIndicatorWidth;
            CGFloat const w = indicatorSize.width > 0 ? indicatorSize.width : (indicatorSize.width + frame.size.width);
            CGFloat const x = frame.origin.x + (frame.size.width - w) * 0.5;
            CGFloat const y = CGRectGetMinY(frame);
            return CGRectMake(x, y, w, h);
            break;
        }
        case UICollectionViewScrollDirectionVertical: {
            CGFloat const w = indicatorSize.width > 0 ? indicatorSize.width : kIndicatorWidth;
            CGFloat const h = indicatorSize.height > 0 ? indicatorSize.height : (indicatorSize.height + frame.size.height);
            CGFloat const y = frame.origin.y + (frame.size.height - h) * 0.5;
            CGFloat const x = CGRectGetMinX(frame);
            return CGRectMake(x, y, w, h);
            break;
        }
        default:
            return CGRectZero;
            break;
    }
}

@end

