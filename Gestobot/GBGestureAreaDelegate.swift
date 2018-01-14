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
    case Up, Down, Left, Right, LUp, RUp, LDown, RDown

}
