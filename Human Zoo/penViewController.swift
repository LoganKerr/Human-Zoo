//
//  penViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/6/18.
//  Copyright © 2018 Logan Kerr. All rights reserved.
//

import UIKit

class penViewController: UIViewController {
    
    // each pen has accessibility label set as pen animal name
    var penName:String? = nil
    // each pen stores one type of human
    var penHuman:Human? = nil
    
    // sets count label as default nil
    var countLabel:UILabel? = nil
    // sets coinsPerMinLabel as default nil
    var coinsPerMinLabel:UILabel? = nil
    // sets sleepButton as default nil
    var wakeUpButton:UIButton? = nil
    // sets sleepView as default nil
    var sleepView:UIView? = nil
    // sets timeTillSleepLabel as default nil
    var timeLeft:UILabel? = nil
    // seconds left until sleep
    var seconds:Int = 0
    // max time before sleep for pen
    var penTime:Int = 0
    // value of each human
    var penValue:Double = 0
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let numberFormatter = NumberFormatter()
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        // Do any additional setup after loading the view, typically from a nib
        
        // gets animal name from accessibilty label
        penName = self.accessibilityLabel as! String
        // gets timeTillSleep of pen human
        for human in HUMANS_LIST
        {
            if (human.getName() == self.penName)
            {
                penHuman = human
                penTime = human.getTime()
                penValue = human.getValue()
            }
        }
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
        
        setLastData()
        
        // observes if a human was rescued and pen must be updated
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanRescued"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,Any>
            let human = info!["human"] as! Human
            let animalNum = info!["animalNum"] as! Int
            let humanName = human.getName()
            
            // if view's accessibility label matches rescued animal
            if (self.penName == humanName)
            {
                self.countLabel?.text = "x"+String(animalNum)
            }
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        // starts timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(timer: Timer)
    {
        seconds = seconds + 1
        UserDefaults.standard.set(seconds, forKey: penName!+"Seconds")
        timeLeft?.text = String(penTime - seconds)+"s\n to sleep"
        if (seconds >= penTime)
        {
            humanSleep()
            stopTimer()
        }
    }
    
    func stopTimer()
    {
        timer.invalidate()
    }
    
    func displaySleep()
    {
        wakeUpButton?.isHidden = false
        sleepView?.isHidden = false
    }
    
    @objc func humanSleep()
    {
        let animalData:[String: Human] = ["human":penHuman!]
        NotificationCenter.default.post(name: NSNotification.Name("humanSleep"), object: nil, userInfo: animalData)
        displaySleep()
    }
    
    @IBAction func wakeUpHuman(_ sender: Any) {
        wakeUpHumanAction()
    }
    
    func wakeUpHumanAction()
    {
        wakeUpButton?.isHidden = true
        let animalData:[String: Any] = ["animalName":penName]
        NotificationCenter.default.post(name: NSNotification.Name("humanWake"), object: nil, userInfo: animalData)
        sleepView?.isHidden = true
        seconds = 0
        scheduledTimerWithTimeInterval()
    }
    
    func calcSinceClose(numHumans: Int, elapsedTime:Int)
    {
        // num of humans in pen
        let count = UserDefaults.standard.integer(forKey: penName!)
        // time until human sleeps BEFORE THE APP WAS CLOSED
        var timeTillSleepBefore:Int = penTime - seconds
        
        if (timeTillSleepBefore > penTime) { timeTillSleepBefore = penTime }
        else if (timeTillSleepBefore < 0)
        {
            timeTillSleepBefore = 0
        }
        
        // placeholder until set
        var secondsTillSleepAfter:Int = timeTillSleepBefore
        // placeholder until set
        var crystalsGainedWhileClosed:Double = 0.0
        
        // if animal was asleep before closing. do nothing
        if (timeTillSleepBefore <= 0)
        {
            // secondsTillSleep was 0 before app was closed, so it must be too now
            secondsTillSleepAfter = 0
            // no crystals are gained while human is asleep
            crystalsGainedWhileClosed = 0
            
            // display sleep and stuff
            displaySleep()
            
            timeTillSleepBefore = 0 // just in case lol
        }
        else
        {
            // animal was awake at time of closing but is asleep now
            if (elapsedTime > timeTillSleepBefore)
            {
                // human has fallen asleep
                secondsTillSleepAfter = 0
                // gained value until sleep
                crystalsGainedWhileClosed = Double(timeTillSleepBefore) * penValue/60 * Double(count)
                
                // display sleep and stuff
                displaySleep()
            }
            else
            {
                // animal was awake at time of closing and is awake now
                secondsTillSleepAfter = timeTillSleepBefore - elapsedTime
                crystalsGainedWhileClosed = Double(elapsedTime) * penValue/60 * Double(count)
                
                // display wake stuff
                scheduledTimerWithTimeInterval()
            }
        }
        let humanData:Dictionary<String,Any> = [
            "human":penHuman,
            "count":count,
            "secondsTillSleep":secondsTillSleepAfter,
            "crystalsGainedWhileClosed":crystalsGainedWhileClosed
        ]
        appDelegate.humanDataDelegate.append(humanData)
        
        // sets seconds counting up to penTime
        seconds = penTime - secondsTillSleepAfter
        UserDefaults.standard.set(seconds, forKey: penName!+"Seconds")
        timeLeft?.text = String(penTime - seconds)+"s\n to sleep"
    }
    
    func setLastData()
    {
        // sets standard labels
        self.countLabel?.text = "x"+String(UserDefaults.standard.integer(forKey: self.penName!))
        self.coinsPerMinLabel?.text = numberFormatter.string(from: NSNumber(value:penValue))!+"\ncrystals/min"
        
        // test stuff below
        var elapsedTime:Int = Int((appDelegate.timeOfOpen!.timeIntervalSince(appDelegate.timeOfClose! as! Date)))
        var crystalsFromThisPen:Double = 0
        seconds = UserDefaults.standard.integer(forKey: self.penName!+"Seconds")
        let numHumanInPen = UserDefaults.standard.integer(forKey: penName!)
        
        calcSinceClose(numHumans: numHumanInPen, elapsedTime: elapsedTime)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
