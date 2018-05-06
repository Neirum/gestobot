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
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let brokerService = GBMqttService()
    let brokerConnectionManager = GBDependencies.shared.brokerConnectionManager
    
    private let movesLimit = 20
    private var movesToSend = [GBGestureDirection]()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        brokerConnectionManager.delegate = self
        configBrokerButtonWithState(state: brokerConnectionManager.state)
    }
    
    
    // MARK: - Navigation
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        gestureView.scale = (segue.source as! GBSettingsViewController).areaScale
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            let settingVC = segue.destination as! GBSettingsViewController
            settingVC.areaScale = gestureView.scale
        }
    }
    
    // MARK: - Actions
    
    @IBAction func resetCommands(_ sender: Any) {
        resetButton.isEnabled = false
        sendButton.isEnabled = false

        movesToSend.removeAll()
        resultLabel.text = ""
    }
    
    @IBAction func sendCommands(_ sender: Any) {
        resetButton.isEnabled = false
        sendButton.isEnabled = false
        
        resultLabel.text = ""
        movesToSend.removeAll()
    }

    // MARK: - Private
    private func configBrokerButtonWithState(state: GBBrokerConnectionState) {
        switch state {
        case .connected:
            brokerButton.backgroundColor = .green
        case .disconnected:
            brokerButton.backgroundColor = .red
        }
    }
    
    private func configViews() {
        gestureView.delegate = self
        brokerButton.layer.cornerRadius = 5.0
        brokerButton.clipsToBounds = true
        robotsButton.layer.cornerRadius = 5.0
        robotsButton.clipsToBounds = true
        
        
        sendButton.setTitleColor(.gray, for: .disabled)
        sendButton.setTitleColor(.lightOrange, for: .normal)

        resetButton.setTitleColor(.gray, for: .disabled)
        resetButton.setTitleColor(.white, for: .normal)
        
        sendButton.isEnabled = false
        resetButton.isEnabled = false
    }
}

// MARK: - GBGestureAreaViewDelegate
extension GBMainViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
    }
    
    func gestureAreaViewTouchBegan() {
        resetButton.isEnabled = true
        sendButton.isEnabled = true

        resultLabel.text = "*"
    }
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        if (movesToSend.count < movesLimit) {
            resultLabel.text = (resultLabel.text ?? "") + "\(direction.rawValue) "
            movesToSend.append(direction)
        }
    }
}

// MARK: - GBBrokerConnectionManagerDelegate
extension GBMainViewController : GBBrokerConnectionManagerDelegate {
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState) {
        configBrokerButtonWithState(state: state)
    }
}
