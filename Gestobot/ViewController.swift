//
//  ViewController.swift
//  Gestobot
//
//  Created by user on 9/19/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gestureView: GBGestureAreaView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var movesCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureView.delegate = self
    }
    
    @IBAction func buttonDidTapped(_ sender: Any) {
        gestureView.scale += 1
    }
 
    @IBAction func unwindToMainScreen(segue: UIStoryboardSegue) {
        gestureView.scale = (segue.source as! GBSettingsViewController).areaScale
    }
    
}

extension ViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
        resultLabel.text = "Touch Ended"
        movesCounter = 0
    }
    
    func gestureAreaViewTouchBegan() {
        resultLabel.text = "TouchStarted"
    }
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        movesCounter += 1
        resultLabel.text = "Moved to : \(direction.rawValue)  moves: \(movesCounter)"
    }
}
