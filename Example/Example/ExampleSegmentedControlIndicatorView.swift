//
//  ExampleSegmentedControlIndicatorView.swift
//  Example
//
//  Created by 徐臻 on 2024/6/28.
//

import UIKit
import XZSegmentedControl

class ExampleSegmentedControlIndicatorView: UICollectionReusableView, XZSegmentedControlIndicatorView {
    
    static func collectionViewLayout(_ flowLayout: UICollectionViewFlowLayout, prepareLayoutForAttributes layoutAttributes: XZSegmentedControlIndicatorLayoutAttributes) {
        layoutAttributes.zIndex = -111
        if !layoutAttributes.frame.isEmpty {
            if flowLayout.scrollDirection == .horizontal {
                layoutAttributes.frame = layoutAttributes.frame.insetBy(dx: 0, dy: 5)
            } else {
                layoutAttributes.frame = layoutAttributes.frame.insetBy(dx: 5, dy: 0)
            }
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        self.superview?.sendSubviewToBack(self)
    }
    
}
