//
//  Human.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/7/18.
//  Copyright © 2018 Logan Kerr. All rights reserved.
//

import Foundation

struct Human
{
    // name of human
    var name: String
    // crystals per min
    var value: Double
    // max time till falls asleep
    var timeTillSleep: Int
    // value of exterminating human
    var valueEx: Double
    
    init(n: String, v: Double, t: Int, ve: Double)
    {
        name = n
        value = v
        timeTillSleep = t
        valueEx = ve
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getValue() -> Double
    {
        return value
    }
    
    func getTime() -> Int
    {
        return timeTillSleep
    }
    
    func getValueEx() -> Double
    {
        return valueEx
    }
}
