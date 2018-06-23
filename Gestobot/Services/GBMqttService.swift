//
//  GBMqttService.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 19.01.18.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation
import CocoaMQTT


protocol GBMqttServiceBrokerConnectionDelegate: AnyObject {
    func didConnectToBroker()
    func didDisconnectBroker(error: Error?)
}

protocol GBMqttServiceMessagesDelegate: AnyObject {
    // sending message
    func messageDidPublish()
    func messagePublishingFailed()
    // receive message
    func didReceiveMessage(topic: String, message: String?)
    func didSubscribeTopic(topic: String)
}


class GBMqttService {
    static let shared = GBMqttService()
    private var cocoaMqtt: CocoaMQTT?
    
    public weak var brokerConnectionDelegate: GBMqttServiceBrokerConnectionDelegate?
    public weak var messagesDelegte: GBMqttServiceMessagesDelegate?
    
    public var brokerHost : String? {
        return cocoaMqtt?.host
    }
    
    public var brokerPort : UInt16? {
        return cocoaMqtt?.port
    }
    
    public var connectionState: CocoaMQTTConnState {
        return cocoaMqtt?.connState ?? .disconnected
    }
    
    func connect(host: String, port: Int) {
        let clientID = "iPhone"
        let mqtt = CocoaMQTT(clientID: clientID, host: host, port: UInt16(port))
        mqtt.keepAlive = 60
        mqtt.delegate = self
        mqtt.connect()
        
        cocoaMqtt = mqtt
    }
    
    func diconnect() {
        cocoaMqtt?.disconnect()
    }
    
    func postMessage(topic: String, message: String) {
        let postMsg = CocoaMQTTMessage.init(topic: topic, string: message)
        cocoaMqtt?.publish(postMsg)
    }
    
    func subscribeTopic(topic: String) {
        cocoaMqtt?.subscribe(topic)
    }
    
}


extension GBMqttService: CocoaMQTTDelegate {
    
    public func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        self.brokerConnectionDelegate?.didConnectToBroker()
    }
    
    public func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        self.brokerConnectionDelegate?.didDisconnectBroker(error: err)
        cocoaMqtt = nil
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("Receive message from topic: \(message.topic)")
        messagesDelegte?.didReceiveMessage(topic: message.topic, message: message.string)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        messagesDelegte?.didSubscribeTopic(topic: topic)
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
    }
    
    public func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        messagesDelegte?.messageDidPublish()
    }
    
    public func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("----------------ping-----------------")
    }
    
    public func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("----------------pong-----------------")
    }

}
