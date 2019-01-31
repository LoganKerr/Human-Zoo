//
//  ViewController.swift
//  Human Zoo
//
//  Created by Logan Kerr on 1/30/19.
//  Copyright © 2019 Logan Kerr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let overlayViewController = OverlayViewController()
    var modelViewController = ModelController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func giveRandomHuman(_ sender: Any) {
        
        self.modelViewController.addHuman(name: "Lawyer")
    }

}
