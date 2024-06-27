//
//  ExampleTestViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/27.
//

import UIKit
import XZSegmentedControl

class ExampleTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let r = CGFloat(arc4random_uniform(256)) / 255.0;
        let g = CGFloat(arc4random_uniform(256)) / 255.0;
        let b = CGFloat(arc4random_uniform(256)) / 255.0;
        view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        

    }
    
    @objc func segmentedControlValueChanged(_ sender: XZSegmentedControl) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
