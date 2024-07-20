//
//  ExampleSegmentedControlIndicator.swift
//  Example
//
//  Created by 徐臻 on 2024/6/28.
//

import UIKit
import XZSegmentedControl

class ExampleSegmentedControlIndicator: XZSegmentedControlIndicator {
    
    override class var supportsInteractiveTransition: Bool {
        return true
    }
    
    override class func segmentedControl(_ segmentedControl: XZSegmentedControl, prepareForLayoutAttributes indicatorLayoutAttributes: XZSegmentedControlIndicatorLayoutAttributes) {
        indicatorLayoutAttributes.zIndex = -111
        
        let selectedIndex = segmentedControl.selectedIndex;
        guard let frame = segmentedControl.layoutAttributesForItem(at: selectedIndex)?.frame else {
            return
        }
        
        if segmentedControl.direction == .horizontal {
            indicatorLayoutAttributes.frame = frame.insetBy(dx: 0, dy: 5)
        } else {
            indicatorLayoutAttributes.frame = frame.insetBy(dx: 5, dy: 0)
        }
        
        let transition = indicatorLayoutAttributes.transition;
        if transition == 0 {
            return
        }
        
        let count = segmentedControl.numberOfSegments;
        
        var newIndex = 0;
        if transition > 0 {
            newIndex = Int(min(CGFloat(count - 1), ceil(CGFloat(selectedIndex) + transition)));
        } else {
            newIndex = Int(max(0.0, floor(CGFloat(selectedIndex) + transition)))
        }
        
        let from = indicatorLayoutAttributes.frame;
        guard var to = segmentedControl.layoutAttributesForItem(at: newIndex)?.frame else {
            return
        }
        
        if segmentedControl.direction == .horizontal {
            to = to.insetBy(dx: 0, dy: 5)
        } else {
            to = to.insetBy(dx: 5, dy: 0)
        }
        
        let percent = abs(transition) / ceil(abs(transition));
        
        let x = from.minX + (to.minX - from.minX) * percent;
        let y = from.minY + (to.minY - from.minY) * percent;
        let w = from.width + (to.width - from.width) * percent;
        let h = from.height + (to.height - from.height) * percent;
        indicatorLayoutAttributes.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
