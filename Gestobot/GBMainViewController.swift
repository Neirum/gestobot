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
    @IBOutlet weak var sendIndicator: UIActivityIndicatorView!
    
    let brokerService = GBMqttService()
    let brokerConnectionManager = GBDependencies.shared.brokerConnectionManager
    let robotsContoroller = GBDependencies.shared.robotsController
    
    private let movesLimit = 20
    private var movesToSend = [GBGestureDirection]()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        robotsContoroller.delegate = self
        configViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        brokerConnectionManager.delegate = self
        configBrokerButtonWith(state: brokerConnectionManager.state)
        configGestureAreaWith(state: brokerConnectionManager.state)
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
        sendIndicator.startAnimating()
        
        robotsContoroller.sendMoves(movesToSend)
        movesToSend.removeAll()
    }

    // MARK: - Private
    private func configBrokerButtonWith(state: GBBrokerConnectionState) {
        switch state {
        case .connected:
            brokerButton.backgroundColor = .green
        case .disconnected:
            brokerButton.backgroundColor = .red
        }
    }
    
    private func configGestureAreaWith(state: GBBrokerConnectionState) {
        if state == .connected {
            gestureView.backgroundColor = .lightOrange
            gestureView.isUserInteractionEnabled = true
        } else if state == .disconnected {
            gestureView.backgroundColor = .darkGray
            gestureView.isUserInteractionEnabled = false
        }
    }
    
    private func configViews() {
        gestureView.delegate = self
        brokerButton.layer.cornerRadius = 5.0
        brokerButton.clipsToBounds = true
        robotsButton.layer.cornerRadius = 5.0
        robotsButton.clipsToBounds = true
        configGestureAreaWith(state: .disconnected)
        
        sendButton.layer.cornerRadius = 5.0
        sendButton.clipsToBounds = true
        sendButton.setTitle("Send", for: .disabled)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.gray, for: .disabled)
        sendButton.setTitleColor(.lightOrange, for: .normal)

        resetButton.layer.cornerRadius = 5.0
        resetButton.clipsToBounds = true
        resetButton.setTitleColor(.gray, for: .disabled)
        resetButton.setTitleColor(.white, for: .normal)
        
        sendButton.isEnabled = false
        resetButton.isEnabled = false
        sendIndicator.hidesWhenStopped = true
    }
}

// MARK: - GBGestureAreaViewDelegate
extension GBMainViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
    }
    
    func gestureAreaViewTouchBegan() {
        resetButton.isEnabled = true
        sendButton.isEnabled = true
        
        if movesToSend.count == 0 {
            resultLabel.text = ""
        }
    }
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        if (movesToSend.count < movesLimit) {
            resultLabel.text = (resultLabel.text ?? "") + "\(direction.rawValue) "
            movesToSend.append(direction)
        }
    }
}

// MARK: - GBRobotsControlManagerDelegate
extension GBMainViewController: GBRobotsControlManagerDelegate {
    
    func movesDidSend() {
        sendIndicator.stopAnimating()
        resetButton.isEnabled = false
        sendButton.isEnabled = false
        
        resultLabel.text = "Sended"
    }
    
    func movesFailToSend(error: GBRobotsControlError) {
        sendIndicator.stopAnimating()
        resetButton.isEnabled = false
        sendButton.isEnabled = false
        
        if error == .noRobots {
            resultLabel.text = "No robots to handling. Add someone"
        } else {
            resultLabel.text = "Fail to send"
        }
    }
    
    func robotDidConnected(_ robot: GBRobot) {}
    func robotStateDidUpdated(robot: GBRobot) {}
}

// MARK: - GBBrokerConnectionManagerDelegate
extension GBMainViewController : GBBrokerConnectionManagerDelegate {
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState) {
        configBrokerButtonWith(state: state)
        configGestureAreaWith(state: state)
    }
}
