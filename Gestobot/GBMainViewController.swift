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
    @IBOutlet weak var brokerButton: UIButton!
    @IBOutlet weak var robotsButton: UIButton!
    
    let brokerService = GBMqttService()
    
    let brokerConnectionManager = GBDependencies.shared.brokerConnectionManager
    
    var movesCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        brokerConnectionManager.delegate = self
        configBrokerButtonWithState(state: brokerConnectionManager.state)
    }
    
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        gestureView.scale += 1
    }
 
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        gestureView.scale = (segue.source as! GBSettingsViewController).areaScale
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let settingVC = segue.destination as! GBSettingsViewController
            settingVC.areaScale = gestureView.scale
        }
    }
    
    
    func configBrokerButtonWithState(state: GBBrokerConnectionState) {
        switch state {
        case .connected:
            brokerButton.backgroundColor = .green
        case .disconnected:
            brokerButton.backgroundColor = .red
        }
    }
    
    func configViews() {
        gestureView.delegate = self
        brokerButton.layer.cornerRadius = 5.0
        brokerButton.clipsToBounds = true
        robotsButton.layer.cornerRadius = 5.0
        robotsButton.clipsToBounds = true
    }
}

extension GBMainViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
//        resultLabel.text = "Touch Ended"
        movesCounter = 0
    }
    
    func gestureAreaViewTouchBegan() {
//        resultLabel.text = "TouchStarted"
        resultLabel.text = "*"
    }
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        movesCounter += 1
//        resultLabel.text = "Moved to : \(direction.rawValue)  moves: \(movesCounter)"
        resultLabel.text = (resultLabel.text ?? "") + "\(direction.rawValue) "
    }
}

extension GBMainViewController : GBBrokerConnectionManagerDelegate {
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState) {
        configBrokerButtonWithState(state: state)
    }
}
