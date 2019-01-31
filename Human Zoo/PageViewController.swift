//
//  PageViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/30/19.
//  Copyright © 2019 Logan Kerr. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var viewControllerList:[UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootView = storyboard.instantiateViewController(withIdentifier: "RootView")
        let ufoHangarView = storyboard.instantiateViewController(withIdentifier: "UfoHangar")
        
        return [ufoHangarView, rootView]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        if let firstViewController = viewControllerList.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // view controller exists
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        // current view controller is not the first one
        guard previousIndex >= 0 else {
            return nil
        }
        // idk what this does
        guard viewControllerList.count > previousIndex else {
            return nil
        }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // view controller exists
        guard let viewControllerIndex = viewControllerList.index(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        // current view controller is not the last one
        guard nextIndex < viewControllerList.count else {
            return nil
        }
        // idk what this does
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        return viewControllerList[nextIndex]
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
