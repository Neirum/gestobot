//
//  GBRobotsControlManager.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 06.05.2018.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation


protocol GBRobotsControlManagerDelegate: AnyObject {
    func movesDidSend()
    func movesFailToSend(error: GBRobotsControlError)
    
    func robotDidConnected(_ robot: GBRobot)
    func robotStateDidUpdated(robot: GBRobot)
}

enum GBRobotsControlError: Error {
    case noRobots
    case failedSend
}

class GBRobotsControlManager {
    
    public weak var delegate: GBRobotsControlManagerDelegate?
    public var robots = [GBRobot]()
    
    private let mqttService = GBMqttService.shared
    
    init() {
        mqttService.messagesDelegte = self
    }
    
    func addRobot(robotId: String) {
        let newRobot = GBRobot(robotId: robotId, name: nil)
        robots.insert(newRobot, at: 0)
        
        mqttService.subscribeTopic(topic: robotId + "/status")
    }
    
    func sendMoves(_ moves: [GBGestureDirection]) {
        guard robots.count != 0 else {
            delegate?.movesFailToSend(error: .noRobots)
            return
        }
        
        
        var movesChars = ""
        
        var prevMove = GBGestureDirection.Up

        for move in moves {
            var currMove = move
            
            if (currMove == prevMove) {
                currMove = .Up
            }
            
            switch currMove {
            case .Up:
                movesChars.append("2")
            case .Down:
                movesChars.append("8")
            case .Left:
                movesChars.append("4")
            case .Right:
                movesChars.append("6")
            default:
                movesChars.append("5")
            }
            
            prevMove = move
        }
        
        if let robot = robots.first {
            mqttService.postMessage(topic: robot.robotId + "/move", message: movesChars)
        }
    }
    
}

extension GBRobotsControlManager: GBMqttServiceMessagesDelegate {
    
    func messageDidPublish() {
        delegate?.movesDidSend()
    }
    
    func messagePublishingFailed() {
        delegate?.movesFailToSend(error: .failedSend)
    }
    
    func didReceiveMessage(topic: String, message: String?) {
        
    }
    
    func didSubscribeTopic(topic: String) {
        
    }
    
}
