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
    
    var timer = Timer()
    var totalHumans: Int = 0
    var crystalsPerMin: Double = 0
    var crystals: Double = 0
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLastData()
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
            print("caught you sleeping");
            let info = notification.userInfo as? Dictionary<String,Any>
            let animalName = info!["animalName"] as! String
            
            // lowers crystals per min of sleeping animal
            // move this to view did load and save to global?
            var value: Double = 0
            var numHumans: Int = (UserDefaults.standard.integer(forKey: animalName) as? Int)!
            for human in HUMANS_LIST
            {
                if (human.getName() == animalName)
                {
                    value = human.getValue() * Double(numHumans)
                }
            }
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
