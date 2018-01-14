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
    @IBOutlet weak var crystalCounter: UILabel!
    @IBOutlet weak var crystalsPerMinLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var timer = Timer()
    var totalHumans: Int = 0
    var crystalsPerMin: Double = 0
    var crystals: Double = 0
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLastData3()
        scheduledTimerWithTimeInterval()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        // Do any additional setup after loading the view, typically from a nib
        
        // observes if a human was rescued and pen must be updated
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanRescued"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,Any>
            let human = info!["human"] as! Human
            let capture = info!["capture"] as! Bool
            
            if (capture)
            {
                // sets new human count
                var numString: String? = self.humanCounter?.text?.components(separatedBy: "\n").first!
                var totalAx: Int = 0
                for charNum in numString!
                {
                    if (charNum != ",")
                    {
                        totalAx = totalAx*10 + Int(String(charNum))!
                    }
                }
                self.humanCounter?.text = self.numberFormatter.string(from: NSNumber(value:Int(totalAx+1)))!+"\nHUMANS"
            
                // sets new crystals per min
                self.crystalsPerMin = self.crystalsPerMin+Double(human.getValue())
                self.crystalsPerMinLabel?.text = self.numberFormatter.string(from: NSNumber(value:Int(self.crystalsPerMin)))!+"\ncrystals/min"
            }
            else
            {
                // sets crystal count after exterminating new human
                self.crystals = self.crystals+human.getValueEx()
                self.crystalCounter?.text = self.numberFormatter.string(from: NSNumber(value: Int(self.crystals)))!
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanSleep"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,Human>
            let human = info!["human"] as! Human
            
            // lowers crystals per min of sleeping animal
            // move this to view did load and save to global?
            var numHumans: Int = (UserDefaults.standard.integer(forKey: human.getName()) as? Int)!
            var value: Double = human.getValue() * Double(numHumans)
            print("SUBTRACTING FROM CRYSTALS PER MIN AHHHHH");
            self.crystalsPerMin = self.crystalsPerMin - value
            self.crystalsPerMinLabel.text = self.numberFormatter.string(from: NSNumber(value:Int(self.crystalsPerMin)))!+"\ncrystals/min"
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("humanWake"), object: nil, queue: nil)
        {
            notification in
            let info = notification.userInfo as? Dictionary<String,Any>
            let animalName = info!["animalName"] as! String
            
            // raises crystals per min of waking animal
            var numHumans: Int = (UserDefaults.standard.integer(forKey: animalName) as? Int)!
            var value: Double = 0
            for human in HUMANS_LIST
            {
                if (human.getName() == animalName)
                {
                    value = human.getValue() * Double(numHumans)
                }
            }
            self.crystalsPerMin = self.crystalsPerMin + value
            self.crystalsPerMinLabel.text = self.numberFormatter.string(from: NSNumber(value:Int(self.crystalsPerMin)))!+"\ncrystals/min"
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        // calls earn crystals every 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.earnCrystals), userInfo: nil, repeats: true)
    }
    
    /*
    func getTotalHumans() -> Array<Any>
    {
        var crystalsPerMin: Double = 0
        for human in HUMANS_LIST
        {
            var numHumans: Int = (UserDefaults.standard.integer(forKey: human.getName()) as? Int)!
            crystalsPerMin = crystalsPerMin + Double(numHumans) * human.getValue()
            self.totalHumans = (self.totalHumans + numHumans)
        }
        return [self.totalHumans, crystalsPerMin]
    }
     */
    
    /*
    func setLastData2()
    {
        print("setting data")
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        if (appDelegate.timeOfClose == nil) { appDelegate.timeOfClose = appDelegate.timeOfOpen }
        
        //if let elapsedTest:Double = appDelegate.timeOfOpen?.timeIntervalSince((appDelegate.timeOfClose?)!)
        var elapsedTime:Int = Int((appDelegate.timeOfOpen?.timeIntervalSince(appDelegate.timeOfClose!))!)
        self.crystals = (UserDefaults.standard.double(forKey: "totalCrystals") as? Double)!
        
        /*
        for arr in appDelegate.humansAwakeOnLoad
        {
            let numHumanInPen = UserDefaults.standard.integer(forKey: human.getName())
            totalHumans = totalHumans + numHumanInPen
            crystalsPerMin = crystalsPerMin + Double(numHumanInPen) * human.getValue()
        }
        
        for human in appDelegate.humansAsleepOnLoad
        {
            let numHumanInPen = UserDefaults.standard.integer(forKey: human.getName())
            totalHumans = totalHumans + numHumanInPen
        }
         */
        /*
        for human in humansAwakeOnLoad
        {
            let timeEarn = min(elapsedTime, secondsTillSleep)
            self.crystals = self.crystals + (crystalsPerMin * timeEarn)
            crystalsPerMin = crystalsPerMin - (human.getValue() * numHumanInPen)
            elapsedTime = elapsedTime - timeEarn
            if (elapsedTime == 0) { break }
        }
         */
        
        // calculate total humans asleep
        for dict in appDelegate.humansAsleepOnLoad
        {
            let human = dict["human"] as! Human
            let numHumanInPen = UserDefaults.standard.integer(forKey: human.getName())
            totalHumans = totalHumans + numHumanInPen
        }
        
        // calculate total humans awake and crystalspermin at end of last session
        for dict in appDelegate.humansAwakeOnLoad
        {
            let human = dict["human"] as! Human
            let numHumanInPen = UserDefaults.standard.integer(forKey: human.getName())
            totalHumans = totalHumans + numHumanInPen
            crystalsPerMin = crystalsPerMin + Double(numHumanInPen) * human.getValue()
        }
        
        print ("elapsedTime: ")
        print(elapsedTime)
        var totalSecondsElapsed:Int = 0
        while appDelegate.humansAwakeOnLoad.count > 0 && elapsedTime > 0
        {
            var timeTillMin = appDelegate.humansAwakeOnLoad[0]["secondsTillSleep"] as! Int - totalSecondsElapsed
            var nextHuman = appDelegate.humansAwakeOnLoad[0]["human"] as! Human
            var minIndex = 0
            // get next human to sleep
            //for dict in appDelegate.humansAwakeOnLoad
            for (index, dict) in appDelegate.humansAwakeOnLoad.enumerated()
            {
                let timeTill = dict["secondsTillSleep"] as! Int - totalSecondsElapsed
                if timeTill < timeTillMin
                {
                    timeTillMin = timeTill
                    nextHuman = dict["human"] as! Human
                    minIndex = index
                }
            }
            print("crystalsPerMin: "+String(crystalsPerMin))
            print("next lowest time: "+String(timeTillMin))
            let timeEarn = min(elapsedTime, timeTillMin)
            let numHumanInPen = UserDefaults.standard.integer(forKey: nextHuman.getName())
            print("gained: "+String(crystalsPerMin/60 * Double(timeEarn)))
            crystals = crystals + (crystalsPerMin/60 * Double(timeEarn))
            // time has passed so human seconds must be decremented
            let nextHumanData:[String: Any] = ["human":nextHuman, "secondsPassed":timeEarn]
            NotificationCenter.default.post(name: NSNotification.Name("timePassedWhileClosed"), object: nil, userInfo: nextHumanData)
            // if animal fell asleep
            if (timeTillMin < elapsedTime)
            {
                print("subtract: "+String(nextHuman.getValue() * Double(numHumanInPen)))
                crystalsPerMin = crystalsPerMin - (nextHuman.getValue() * Double(numHumanInPen))
                
            }
            elapsedTime = elapsedTime - timeEarn
            totalSecondsElapsed = totalSecondsElapsed + timeEarn
            appDelegate.humansAwakeOnLoad.remove(at: minIndex)
        }
        print("crystalsPerMinFinal: "+String(crystalsPerMin))
        
        
        // set total humans
        humanCounter.text = numberFormatter.string(from: NSNumber(value:Int(totalHumans)))!+"\nHUMANS"
        
        // set total crystals
        crystalCounter.text = numberFormatter.string(from: NSNumber(value:Int(crystals)))!+"\ncrystals/min"
        
        // set crystals per min
        crystalsPerMinLabel.text = numberFormatter.string(from: NSNumber(value:Int(crystalsPerMin)))!+"\ncrystals/min"
        
    }
 */
    
    func setLastData3()
    {
        var testGained:Double = 0.0
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        print(appDelegate.humanDataDelegate)
        
        // gets and sets globals
        for dict in appDelegate.humanDataDelegate
        {
            // set number of humans
            let numHumansInPen = dict["count"] as! Int
            totalHumans = totalHumans + numHumansInPen
            let secondsTillSleep = dict["secondsTillSleep"] as! Int
            // if human is awake
            if (secondsTillSleep > 0)
            {
                let human = dict["human"] as! Human
                let value = human.getValue()
                // it is generating crystals per min
                crystalsPerMin = crystalsPerMin + Double(numHumansInPen) * value
            }
            let crystalsGained = dict["crystalsGainedWhileClosed"] as! Double
            testGained = testGained + crystalsGained
            crystals = crystals + crystalsGained
        }
        
        // sets total humans label
        humanCounter.text = numberFormatter.string(from: NSNumber(value:Int(totalHumans)))!+"\nHUMANS"
        
        // sets total crystals label
        self.crystals = (UserDefaults.standard.double(forKey: "totalCrystals") as? Double)!
        crystalCounter.text = numberFormatter.string(from: NSNumber(value:Int(crystals)))!+"\ncrystals/min"
        
        print("crystals Gained: "+String(testGained))
        
        // sets crystals per min label
        crystalsPerMinLabel.text = numberFormatter.string(from: NSNumber(value:Int(crystalsPerMin)))!+"\ncrystals/min"
    }
    
    /*
    func setLastData()
    {
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        var properties: Array<Any> = getTotalHumans()
        // sets total humans
        self.totalHumans = (properties[0] as? Int)!
        humanCounter.text = numberFormatter.string(from: NSNumber(value:Int(totalHumans)))!+"\nHUMANS"
        
        // sets total crystals
        self.crystals = (UserDefaults.standard.double(forKey: "totalCrystals") as? Double)!
        crystalCounter.text = numberFormatter.string(from: NSNumber(value:Int(crystals)))!+"\ncrystals/min"
        
        // sets crystals per min
        self.crystalsPerMin = (properties[1] as? Double)!
        crystalsPerMinLabel.text = numberFormatter.string(from: NSNumber(value:Int(crystalsPerMin)))!+"\ncrystals/min"
    }
 */
    
    @objc func earnCrystals()
    {
        self.crystals = self.crystals + Double(crystalsPerMin/60)
        UserDefaults.standard.set(crystals, forKey: "totalCrystals")
        crystalCounter.text = numberFormatter.string(from: NSNumber(value:Int(crystals)))!+"\ncrystals/min"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
