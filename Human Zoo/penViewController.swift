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
    // sets coinsPerMinLabel as default nil
    var coinsPerMinLabel:UILabel? = nil
    // sets sleepButton as default nil
    var wakeUpButton:UIButton? = nil
    // sets sleepView as default nil
    var sleepView:UIView? = nil
    // sets timeTillSleepLabel as default nil
    var timeLeft:UILabel? = nil
    var seconds:Int = 0
    
    let numberFormatter = NumberFormatter()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
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
                else if (labelView.accessibilityLabel == "coinsPerMin")
                {
                    // sets updated coins per min
                    coinsPerMinLabel = labelView
                }
                else if (labelView.accessibilityLabel == "timeTillSleepLabel")
                {
                    timeLeft = labelView
                }
            }
            else if let labelView = view as? UIButton
            {
                if (labelView.accessibilityLabel == "wakeUpButton")
                {
                    wakeUpButton = labelView
                }
            }
            else if let labelView = view as? UIView
            {
                if(labelView.accessibilityLabel == "sleepView")
                {
                    sleepView = labelView
                }
            }
        }
        scheduledTimerWithTimeInterval()
        
        // observes if a human was rescued and pen must be updated
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanRescued"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,Any>
            let human = info!["human"] as! Human
            let animalNum = info!["animalNum"] as! Int
            let animalName = human.getName()
            
            // if view's accessibility label matches rescued animal
            if (self.viewLabel == animalName)
            {
                self.countLabel?.text = "x"+String(animalNum)
            }
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        // calls earn crystals every 5 seconds
        var time: Double = 0
        for human in HUMANS_LIST
        {
            if (human.getName() == self.viewLabel)
            {
                time = human.getTime()
            }
        }
        let timeData:[String: Any] = ["timeData":time]
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: ["time" : time], repeats: true)
    }
    
    @objc func updateTimer(timer: Timer)
    {
        seconds = seconds + 1
        let userInfo = timer.userInfo as! Dictionary<String, Any>
        var time:Int = userInfo["time"] as! Int
        if (seconds >= time)
        {
            humanSleep()
            seconds = 0
        }
        else
        {
        timeLeft?.text = String(time - seconds)+"s\n to sleep"
        }
    }
    
    func stopTimer()
    {
        print("stopping timer")
        timer.invalidate()
    }
    
    @objc func humanSleep()
    {
        print("oh no feell asleep");
        wakeUpButton?.isHidden = false
        let animalData:[String: Any] = ["animalName":viewLabel]
        NotificationCenter.default.post(name: NSNotification.Name("humanSleep"), object: nil, userInfo: animalData)
        sleepView?.isHidden = false
        stopTimer()
    }
    
    @IBAction func wakeUpHuman(_ sender: Any) {
        print(viewLabel!+" pushed this button")
        wakeUpButton?.isHidden = true
        let animalData:[String: Any] = ["animalName":viewLabel]
        NotificationCenter.default.post(name: NSNotification.Name("humanWake"), object: nil, userInfo: animalData)
        sleepView?.isHidden = true
        scheduledTimerWithTimeInterval()
    }
    
    func setLastData()
    {
        self.countLabel?.text = "x"+String(UserDefaults.standard.integer(forKey: self.viewLabel!))
        for human in HUMANS_LIST
        {
            if (human.getName() == self.viewLabel)
            {
                self.coinsPerMinLabel?.text = numberFormatter.string(from: NSNumber(value:human.getValue()))!+"\ncrystals/min"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
