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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureView.delegate = self
    }

    
    @IBAction func buttonDidTapped(_ sender: Any) {
        gestureView.scale += 1
    }
    
}

extension ViewController: GBGestureAreaViewDelegate {
    
    func gestureAreaViewTouchEnded() {
        resultLabel.text = "Touch Ended"
    }
    
    func gestureAreaViewTouchBegan() {
        resultLabel.text = "TouchStarted"
    }
    
    
    func gestureAreaViewTouchMovedIn(direction: GBGestureDirection) {
        resultLabel.text = "Moved to : \(direction.rawValue)"
    }
}
