//
//  penViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/6/18.
//  Copyright © 2018 Logan Kerr. All rights reserved.
//

import UIKit

class penViewController: UIViewController {
    
    // sets count label as default nil
    var countLabel:UILabel? = nil
    // each pen has accessibility label set as pen animal name
    var viewLabel:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        // gets animal name from accessibilty label
        viewLabel = self.accessibilityLabel as! String
        // for each view in view controller
        for view in self.view.subviews
        {
            // if casting to label works
            if let labelView = view as? UILabel
            {
                // if restoration id matches
                if (labelView.accessibilityLabel == "count")
                {
                    // sets updated animal count
                    countLabel = labelView
                }
            }
        }
        
        // observes if a human was rescued and pen must be updated
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanRescued"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,String>
            let animalNum = info!["animalNum"] as! String
            let animalName = info!["animalName"] as! String
            
            // if view's accessibility label matches rescued animal
            if (self.viewLabel == animalName)
            {
                self.countLabel?.text = "x"+animalNum
            }
        }
    }
    
    func setLastData()
    {
        self.countLabel?.text = "x"+String(UserDefaults.standard.integer(forKey: self.viewLabel!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
