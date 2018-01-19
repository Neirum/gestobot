//
//  ViewController.swift
//  Gestobot
//
//  Created by user on 9/19/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit

class GBMainViewController: UIViewController {

    @IBOutlet weak var gestureView: GBGestureAreaView!
    @IBOutlet weak var resultLabel: UILabel!
    
    let brokerService = GBMqttService()
    
    var movesCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureView.delegate = self
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        gestureView.scale += 1
    }
 
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        gestureView.scale = (segue.source as! GBSettingsViewController).areaScale
    }
    
    @IBAction func connectButtonDidTapped(_ sender: Any) {
        brokerService.connect()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let settingVC = segue.destination as! GBSettingsViewController
            settingVC.areaScale = gestureView.scale
        }
    }
    
}

extension GBMainViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
        resultLabel.text = "Touch Ended"
        movesCounter = 0
    }
    
    func gestureAreaViewTouchBegan() {
        resultLabel.text = "TouchStarted"
    }
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        movesCounter += 1
        resultLabel.text = "Moved to : \(direction.rawValue)  moves: \(movesCounter)"
    }
}
