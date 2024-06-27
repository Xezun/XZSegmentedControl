//
//  Example2ViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/26.
//

import UIKit
import XZSegmentedControl

class Example2ViewController: UIViewController {

    @IBOutlet weak var segmentedControl: XZSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.indicatorSize  = CGSize.init(width: 3.0, height: 10.0)
        segmentedControl.titles = ["业界", "手机", "电脑", "测评", "视频", "AI", "苹果", "鸿蒙", "软件", "数码"]
        segmentedControl.itemSpacing = 10;
        
        let headerView = UIButton.init(type: .system)
        headerView.setTitle(" + ", for: .normal)
        headerView.backgroundColor = .white
        headerView.frame.size = CGSize.init(width: 40, height: 40)
        segmentedControl.headerView = headerView
        
        let footerView = UIButton.init(type: .system)
        footerView.setTitle(" - ", for: .normal)
        footerView.backgroundColor = .white
        footerView.frame.size = CGSize.init(width: 40, height: 40)
        segmentedControl.footerView = footerView
        
    }
    
}
