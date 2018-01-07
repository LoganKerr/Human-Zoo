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
    var value: Int
    
    init(n: String, v: Int)
    {
        name = n
        value = v
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getValue() -> Int
    {
        return value
    }
}
