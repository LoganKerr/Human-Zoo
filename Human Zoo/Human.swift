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
    var name: String
    var value: Double
    var timeTillSleep: Double
    var valueEx: Double
    
    init(n: String, v: Double, t: Double, ve: Double)
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
    
    func getTime() -> Double
    {
        return timeTillSleep
    }
    
    func getValueEx() -> Double
    {
        return valueEx
    }
}
