//
//  GBSettingsViewController.swift
//  Gestobot
//
//  Created by user on 9/25/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit

class GBSettingsViewController: UIViewController {

    @IBOutlet weak var scaleLabel: UILabel!
    
    public var areaScale: Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateScaleLabel()
    }


    
    @IBAction func plusButtonDidTapped(_ sender: GBRoundButton) {
        if areaScale < 8 {
            areaScale += 1
            updateScaleLabel()
        }
    }
    
    @IBAction func minusButtonDidTapped(_ sender: GBRoundButton) {
        if areaScale > 2 {
            areaScale -= 1
            updateScaleLabel()
        }
    }

    func updateScaleLabel() {
        scaleLabel.text = "\(areaScale)x\(areaScale)"
    }
    
}
