//
//  GBGestureAreaDelegate.swift
//  Gestobot
//
//  Created by user on 9/22/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import Foundation

protocol GBGestureAreaViewDelegate {
    func gestureAreaViewTouchBegan()
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection)
    func gestureAreaViewTouchEnded()
}


enum GBGestureDirection: String {
    case Up = "↑"
    case Down = "↓"
    case Left = "←"
    case Right = "→"
    case LUp = "↖"
    case RUp = "↗"
    case LDown = "↙"
    case RDown = "↘"

}
