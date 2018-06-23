//
//  GBBrokerConnectionViewController.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 01.05.2018.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import UIKit

class GBBrokerConnectionViewController: UIViewController {

    @IBOutlet weak var connectedBrokerIpLabel: UILabel!
    @IBOutlet weak var connectedBrokerPortLabel: UILabel!

    @IBOutlet weak var brokerHostTextField: UITextField!
    @IBOutlet weak var brokerPortTextField: UITextField!

    @IBOutlet weak var connectButton: UIButton!
    
    private var brokerConnectionManager = GBDependencies.shared.brokerConnectionManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
        brokerConnectionManager.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        brokerPortTextField.text = "1883";
        brokerHostTextField.text = "192.168.0."
    }
    
    // MARK: - Actions
    @IBAction func disconnectCurrentBroker(_ sender: Any) {
        brokerConnectionManager.disconnect()
    }
    
    @IBAction func connectToBroker(_ sender: Any) {
        view.endEditing(true)
        guard
            let host = brokerHostTextField.text,
            let portText = brokerPortTextField.text,
            let port = Int(portText)
            else { return }
        brokerConnectionManager.connect(host: host, port: port)
    }
    
    // MARK: - Private
    func configViews() {
        
        
        connectButton.setTitleColor(.lightOrange, for: .normal)
        connectButton.setTitleColor(.gray, for: .disabled)
        connectButton.isEnabled = brokerConnectionManager.state == .disconnected
        
        if brokerConnectionManager.state == .disconnected {
//            brokerHostTextField.text = UserDefaults.standard.string(forKey: "lastBrokerHost")
//            brokerPortTextField.text = UserDefaults.standard.string(forKey: "lastBrokerPort")
            
            connectedBrokerPortLabel.text = "N/A"
            connectedBrokerIpLabel.text = "N/A"
        } else {
            brokerPortTextField.text = nil
            brokerHostTextField.text = nil
            
            connectedBrokerPortLabel.text = brokerConnectionManager.port
            connectedBrokerIpLabel.text = brokerConnectionManager.host
        }
    }
    
    func saveLastBroker(host: String, port: String) {
//        UserDefaults.standard.setValue(host, forKey: "lastBrokerHost")
//        UserDefaults.standard.setValue(port, forKey: "lastBrokerPort")
    }
}

// MARK: - GBBrokerConnectionManagerDelegate
extension GBBrokerConnectionViewController : GBBrokerConnectionManagerDelegate {
    
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState) {
        configViews()
    }
}
