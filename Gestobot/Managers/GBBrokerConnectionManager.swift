//
//  GBBrokerConnectionManager.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 01.05.2018.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation


public enum GBBrokerConnectionState: UInt {
    case connected
    case disconnected
}

protocol GBBrokerConnectionManagerDelegate {
    func brokerConnectionStateDidUpdate(state: GBBrokerConnectionState)
}


class GBBrokerConnectionManager {
    
    var delegate: GBBrokerConnectionManagerDelegate?
    
    var host : String {
        return mqttService.brokerHost ?? "N/A"
    }
    
    var port : String {
        if let portNum = mqttService.brokerPort {
            return "\(portNum)"
        } else {
            return "N/A"
        }
    }
    
    var state: GBBrokerConnectionState {
        switch mqttService.connectionState() {
        case .connected:
            return .connected
        default:
            return .disconnected
        }
    }
    
    private let mqttService = GBMqttService.shared
    
    init() {
        mqttService.brokerConnectionDelegate = self
    }
    
    func connect(host: String, port: Int) {
        mqttService.connect(host: host, port: port)
    }
    
    func disconnect() {
        mqttService.diconnect()
    }
}

extension GBBrokerConnectionManager : GBMqttServiceBrokerConnectionDelegate {
    
    func didConnectToBroker() {
        self.delegate?.brokerConnectionStateDidUpdate(state: .connected)
    }
    
    func didDisconnectBroker(error: Error?) {
        self.delegate?.brokerConnectionStateDidUpdate(state: .disconnected)
        print("Disconnected broker error : \(error?.localizedDescription ?? "?")")
    }

}
