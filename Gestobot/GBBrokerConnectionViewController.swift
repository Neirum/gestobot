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
    
    var brokerConnectionManager: GBBrokerConnectionManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectedBrokerPortLabel.text = "..."
        connectedBrokerIpLabel.text = "..."
        
        brokerConnectionManager = GBDependencies.shared.brokerConnectionManager
        brokerConnectionManager.delegate = self
    }

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
}

extension GBBrokerConnectionViewController : GBBrokerConnectionManagerDelegate {
    
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState) {
        switch state {
        case .connected:
            self.connectedBrokerIpLabel.text = brokerConnectionManager.host
            self.connectedBrokerPortLabel.text = brokerConnectionManager.port
        case .disconnected:
            self.connectedBrokerIpLabel.text = "----"
            self.connectedBrokerPortLabel.text = "---"
        }
    }
}
