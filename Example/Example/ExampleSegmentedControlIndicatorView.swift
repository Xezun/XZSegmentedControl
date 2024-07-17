//
//  ExampleSegmentedControlIndicatorView.swift
//  Example
//
//  Created by 徐臻 on 2024/6/28.
//

import UIKit
import XZSegmentedControl

class ExampleSegmentedControlIndicatorView: XZSegmentedControlIndicator {
    
    override class func segmentedControl(_ segmentedControl: XZSegmentedControl, prepareForLayoutAttributes indicatorLayoutAttributes: XZSegmentedControlIndicatorLayoutAttributes) {
        indicatorLayoutAttributes.zIndex = -111
        
        let frame = segmentedControl.layoutAttributesForItem(at: segmentedControl.selectedIndex).frame;
        if segmentedControl.direction == .horizontal {
            indicatorLayoutAttributes.frame = frame.insetBy(dx: 0, dy: 5)
        } else {
            indicatorLayoutAttributes.frame = frame.insetBy(dx: 5, dy: 0)
        }
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
