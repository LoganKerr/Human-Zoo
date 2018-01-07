//
//  overlayViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/6/18.
//  Copyright © 2018 Logan Kerr. All rights reserved.
//

import UIKit

class overlayViewController: UIViewController {
    
    @IBOutlet weak var humanCounter: UILabel!
    // sets human counter label as default nil
    //var humanCounter:UILabel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLastData()
        // Do any additional setup after loading the view, typically from a nib
        
        // observes if a human was rescued and pen must be updated
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanRescued"), object: nil, queue: nil)
        {
            notification in
            var prevData: Int? = Int((self.humanCounter?.text?.components(separatedBy: "\n").first!)!)
            self.humanCounter?.text = String(prevData!+1)+"\nHUMANS"
        }
    }
    
    func getTotalHumans() -> Int
    {
        var total: Int = 0
        for human in HUMANS_LIST
        {
            total = (total + UserDefaults.standard.integer(forKey: human.getName()) as? Int)!
        }
        return total
    }
    
    func setLastData()
    {
        var totalHumans = getTotalHumans()
        humanCounter.text = String(totalHumans)+"\nHUMANS"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
