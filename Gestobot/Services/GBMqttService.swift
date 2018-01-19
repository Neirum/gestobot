//
//  GBMqttService.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 19.01.18.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation
import CocoaMQTT

class GBMqttService {
    
    func connect() {
        let clientID = "iPhone"
        let mqtt = CocoaMQTT(clientID: clientID, host: "192.168.33.29", port: 1883)

        mqtt.willMessage = CocoaMQTTWill(topic: "/will", message: "dieout")
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.connect()
    }
}


extension GBMqttService: CocoaMQTTDelegate {
    
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnect with ack: \(ack.rawValue)");
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {

    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("Receive message from topic: \(message.topic)")
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        
    }

}
