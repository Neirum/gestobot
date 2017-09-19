//
//  GBGestureArea.swift
//  Gestobot
//
//  Created by user on 9/19/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit


@IBDesignable class GBGestureArea: UIView {


    @IBInspectable var scale: Int = 2
    var lineWidth: CGFloat = 5.0
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if scale > 1 {
            drawMesh(rect)
        }
    }
    
    func drawMesh(_ rect: CGRect) {
        let sectionsCount = scale
        let linesCount = sectionsCount - 1
        let sectionWidth = ( rect.width - lineWidth * CGFloat(linesCount) ) / CGFloat(sectionsCount)
        
        
        let path = UIBezierPath()
        
        for i in 0..<linesCount {
            let xPoint = (sectionWidth + (sectionWidth + lineWidth) * CGFloat(i))
            drawLine(from: CGPoint(x: xPoint, y: 0),
                       to: CGPoint(x: xPoint, y: rect.height),
                       by: path)
            
            drawLine(from: CGPoint(x: 0, y: xPoint),
                     to: CGPoint(x: rect.width, y: xPoint),
                     by: path)
        }
        
        
        path.lineWidth = lineWidth
        UIColor.white.setFill()
        UIColor.white.setStroke()
        path.stroke()
        
    }

    
    private func drawLine(from startPoint: CGPoint, to endPoint: CGPoint, by path: UIBezierPath) {
        path.move(to: startPoint)
        path.addLine(to: endPoint)
    }

}
