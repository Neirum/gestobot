//
//  GBDependecies.swift
//  Gestobot
//
//  Created by Stas Zherebkin on 01.05.2018.
//  Copyright © 2018 StasZherebkin. All rights reserved.
//

import Foundation


class GBDependencies {
    
    static let shared = GBDependencies()
    
    
    public lazy var brokerConnectionManager = GBBrokerConnectionManager()
    
    
}
