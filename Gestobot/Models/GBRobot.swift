//
//  GBRobot.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 06.05.2018.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation


public enum GBRobotState {
    case ready
    case processing
    case unawailable
}


struct GBRobot {
    
    let robotId: String
    var name: String
    var robotState: GBRobotState = .unawailable
    
    init(robotId: String, name: String?) {
        self.name = name ?? robotId
        self.robotId = robotId
    }
    
}
