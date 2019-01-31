//
//  PenViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/30/19.
//  Copyright © 2019 Logan Kerr. All rights reserved.
//

import UIKit

class PenViewController: UIViewController {

    var dataObject: String = ""
    @IBOutlet weak var humanName: UILabel!
    
    override func viewDidLoad() {
        //viewController.dataSource = self
        super.viewDidLoad()
        humanName.text = dataObject
        // Do any additional setup after loading the view.
    }
    

}
