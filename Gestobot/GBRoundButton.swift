//
//  GBRoundButton.swift
//  Gestobot
//
//  Created by user on 9/25/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit

@IBDesignable
class GBRoundButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.red
    @IBInspectable var isAddButton: Bool = true
    

    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill();
        path.fill();
        
        let plusHeight: CGFloat = 3.0;
        let plusWidth: CGFloat = bounds.size.height * 0.6;
        
        let plusPath = UIBezierPath();
        plusPath.lineWidth = plusHeight;
        
     
        plusPath.move(to: CGPoint(x: bounds.size.width/2 - plusWidth/2, y: bounds.size.height/2));
        plusPath.addLine(to: CGPoint(x: bounds.size.width/2 + plusWidth/2, y: bounds.size.height/2))

        
        if isAddButton {
            plusPath.move(to:CGPoint(x: bounds.size.width/2, y: bounds.size.height/2 - plusWidth/2));
            plusPath.addLine(to: CGPoint(x: bounds.size.width/2, y: bounds.size.height/2 + plusWidth/2));
            plusPath.stroke();
        }
        
        UIColor.white.setStroke();
        plusPath.stroke();
    }


}
