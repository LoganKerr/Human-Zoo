//
//  MyPageViewController.swift
//  test Embedded page
//
//  Created by Logan Kerr on 12/21/17.
//  Copyright © 2017 Logan Kerr. All rights reserved.
//

import UIKit

class MyPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let hangarPage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "hangarPage")
        hangarPage.accessibilityLabel = "hangar"
        let _ = hangarPage.view
        let homePage: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "homePage")
        homePage.accessibilityLabel = "home"
        let _ = homePage.view
        let farmerPen: penViewController! = (storyboard?.instantiateViewController(withIdentifier: "farmerPen"))! as! penViewController
        farmerPen.accessibilityLabel = "farmer"
        let _ = farmerPen.view
        farmerPen.setLastData()
        let teacherPen: penViewController! = (storyboard?.instantiateViewController(withIdentifier: "teacherPen"))! as! penViewController
        teacherPen.accessibilityLabel = "teacher"
        let _ = teacherPen.view
        teacherPen.setLastData()
        let cashierPen: penViewController! = (storyboard?.instantiateViewController(withIdentifier: "cashierPen"))! as! penViewController
        cashierPen.accessibilityLabel = "cashier"
        let _ = cashierPen.view
        cashierPen.setLastData()
        
        pages.append(hangarPage)
        pages.append(homePage)
        pages.append(farmerPen)
        pages.append(teacherPen)
        pages.append(cashierPen)
        
        setViewControllers([homePage], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
 
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

