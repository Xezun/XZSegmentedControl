//
//  ExampleViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/12.
//

import UIKit
import XZSegmentedControl

class ExampleViewController: UIViewController {

    @IBOutlet weak var segmentedControl: XZSegmentedControl!
    var pageViewController: UIPageViewController!
    
    let titles = ["业界", "手机", "电脑", "测评", "视频", "AI", "苹果", "鸿蒙", "软件", "数码"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if segmentedControl.direction == .horizontal {
            segmentedControl.indicatorSize  = CGSize.init(width: 20.0, height: 3.0)
        } else {
            segmentedControl.indicatorSize  = CGSize.init(width: 3.0, height: 20.0)
        }
        segmentedControl.indicatorColor = .systemRed
        segmentedControl.titles         = self.titles
        segmentedControl.itemSpacing    = 10;
        segmentedControl.titleFont      = .systemFont(ofSize: 17.0)
        segmentedControl.selectedTitleFont = .boldSystemFont(ofSize: 18.0)
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        pageViewController.delegate = self;
        pageViewController.dataSource = self
        pageViewController.setViewControllers([viewControllers[0]], direction: .forward, animated: false)
    }

    @objc func segmentedControlValueChanged(_ sender: XZSegmentedControl) {
        let newIndex = sender.selectedIndex;
        print("valueChanged: \(newIndex)")
        
        if let viewController = pageViewController.viewControllers?.first {
            if let oldIndex = viewControllers.firstIndex(of: viewController) {
                if newIndex > oldIndex {
                    pageViewController.setViewControllers([viewControllers[newIndex]], direction: .forward, animated: true)
                } else {
                    pageViewController.setViewControllers([viewControllers[newIndex]], direction: .reverse, animated: true)
                }
            } else {
                pageViewController.setViewControllers([viewControllers[newIndex]], direction: .forward, animated: true)
            }
        } else {
            pageViewController.setViewControllers([viewControllers[newIndex]], direction: .forward, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "page" {
            
        }
        switch identifier {
        case "page":
            pageViewController = segue.destination as? UIPageViewController;
        case "settings":
            if let vc = segue.destination as? ExampleSettingsViewController {
                vc.segmentedControl = self.segmentedControl
            }
        default:
            fatalError()
        }
    }
    
    

    lazy var viewControllers: [UIViewController] = titles.map { title in
        let vc = ExampleTestViewController.init()
        vc.title = title
        return vc
    }
    
}

extension ExampleViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        if index == 0 {
            return nil
        }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController) else { return nil }
        if index == viewControllers.count - 1 {
            return nil
        }
        return viewControllers[index + 1]
    }
}

extension ExampleViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        guard let viewController = pageViewController.viewControllers?.first else { return }
        guard let index = viewControllers.firstIndex(of: viewController) else { return }
        self.segmentedControl.setSelectedIndex(index, animated: true)
    }
}
