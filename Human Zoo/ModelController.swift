//
//  ModelController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/30/19.
//  Copyright © 2019 Logan Kerr. All rights reserved.
//

import UIKit

class ModelController: NSObject, UIPageViewControllerDataSource {
    var overlayViewController = OverlayViewController()
    var humans = [""]
    let defaults = UserDefaults.standard
    let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
    
    var pageViewController: UIPageViewController?
    
    override init() {
        super.init()
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        self.humans = self.defaults.stringArray(forKey: "SavedStringArray") ?? [String]()
        
        if self.humans == [""] || self.humans.count == 0  {
            self.humans = ["Farmers", "Cashiers"]
        }
    }
    
    func addHuman(name:String) {
        self.humans.append(name)
        self.defaults.set(self.humans, forKey: "SavedStringArray")
        
        /*
         let startingViewController: DataViewController = self.viewControllerAtIndex(5, storyboard: self.rootViewController.storyboard!)!
         let viewControllers = [startingViewController]
         
         self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
         
         
         self.rootViewController.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
         */
        
    }
    
    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> PenViewController? {
        // Return the data view controller for the given index.
        if (self.humans.count == 0) || (index >= self.humans.count) {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        let penViewController = storyboard.instantiateViewController(withIdentifier: "PenViewController") as! PenViewController
        
        //get human name
        penViewController.dataObject = self.humans[index]
        
        return penViewController
    }
    
    func indexOfViewController(_ viewController: PenViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return self.humans.index(of: viewController.dataObject) ?? NSNotFound
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PenViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! PenViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.humans.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }
}
