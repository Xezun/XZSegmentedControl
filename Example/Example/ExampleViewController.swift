//
//  ExampleViewController.swift
//  Example
//
//  Created by 徐臻 on 2024/6/12.
//

import UIKit
import XZSegmentedControl

class ExampleViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var segmentedControl: XZSegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let titles = ["业界", "手机", "电脑", "测评", "视频", "AI", "苹果", "鸿蒙", "软件", "数码"];
    var views  = [UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in titles {
            let view = UIView.init()
            let r = CGFloat(arc4random_uniform(256)) / 255.0;
            let g = CGFloat(arc4random_uniform(256)) / 255.0;
            let b = CGFloat(arc4random_uniform(256)) / 255.0;
            view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
            views.append(view)
            
            scrollView.addSubview(view)
        }
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var frame = scrollView.frame;
        frame.origin = .zero
        if segmentedControl.direction == .horizontal {
            for view in views {
                view.frame = frame
                frame.origin.x += frame.width
            }
            scrollView.contentSize = .init(width: frame.origin.x, height: 0)
        } else {
            for view in views {
                view.frame = frame
                frame.origin.y += frame.height
            }
            scrollView.contentSize = .init(width: 0, height: frame.origin.y)
        }
    }

    @objc func segmentedControlValueChanged(_ sender: XZSegmentedControl) {
        let newIndex = sender.selectedIndex;
        print("valueChanged: \(newIndex)")
        if segmentedControl.direction == .horizontal {
            scrollView.setContentOffset(.init(x: scrollView.frame.width * CGFloat(newIndex), y: 0), animated: false)
        } else {
            scrollView.setContentOffset(.init(x: 0, y: scrollView.frame.height * CGFloat(newIndex)), animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset;
        if segmentedControl.direction == .horizontal {
            let width = scrollView.frame.width;
            segmentedControl.setSelectedIndex(Int(contentOffset.x / width), animated: true)
            let delta = contentOffset.x - CGFloat(segmentedControl.selectedIndex) * width
            segmentedControl.indicatorTransiton = delta / width;
        } else {
            let height = scrollView.frame.height;
            segmentedControl.setSelectedIndex(Int(contentOffset.y / height), animated: true)
            let delta = contentOffset.y - CGFloat(segmentedControl.selectedIndex) * height
            segmentedControl.indicatorTransiton = delta / height;
        }
        print("\(#function) selectedIndex: \(segmentedControl.selectedIndex), indicatorTransiton: \(segmentedControl.indicatorTransiton)")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("\(#function) decelerate = \(decelerate)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("\(#function)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        if identifier == "page" {
            
        }
        switch identifier {
        case "page":
            break
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
