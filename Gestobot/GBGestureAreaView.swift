//
//  GBGestureArea.swift
//  Gestobot
//
//  Created by user on 9/19/17.
//  Copyright © 2017 StasZherebkin. All rights reserved.
//

import UIKit


@IBDesignable class GBGestureAreaView: UIView {
    
    public var delegate: GBGestureAreaViewDelegate?
    
    private var sectionsCount: Int {
        return scale
    }
    
    private var linesCount: Int {
        return sectionsCount - 1
    }
    
    @IBInspectable var scale: Int = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 5.0

    private var sectionWidth: CGFloat!
    
    private var prevTouchPoint: CGPoint = CGPoint.zero
    
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first else { return }
        prevTouchPoint = touch.location(in: self)
        delegate?.gestureAreaViewTouchBegan()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        checkTouchWithNewPoint(touch.location(in: self))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.gestureAreaViewTouchEnded()
    }
    
    // MRK: - Gesture Calculation
    private func checkTouchWithNewPoint(_ point: CGPoint) {
        guard let direction = directionOfMotion(from: self.prevTouchPoint, to: point) else {
            return
        }
        prevTouchPoint = point
        delegate?.gestureAreaViewTouchMovedIn(direction: direction)
    }
    
    private func directionOfMotion(from startPoint: CGPoint, to finishPoint: CGPoint) -> GBGestureDirection? {
        let startPoint = coordOfRectFor(startPoint)
        let finishPoint = coordOfRectFor(finishPoint)

        return directionFor(startCoord: startPoint, finishCoord: finishPoint)
    }
    
    private func coordOfRectFor(_ point: CGPoint) -> (x: Int, y: Int) {
        let rectWidth = bounds.size.width / CGFloat(sectionsCount)
        let xPoint = Int(point.x / rectWidth)
        
        let rectHigh = bounds.size.height / CGFloat(sectionsCount)
        let yPoint =  Int(point.y / rectHigh)
        
        return (xPoint, yPoint)
    }
    
    private func directionFor(startCoord: (x: Int, y: Int), finishCoord: (x: Int, y: Int) ) -> GBGestureDirection? {
        let x = finishCoord.x - startCoord.x
        let y = finishCoord.y - startCoord.y
        
        var direction: GBGestureDirection? = nil

        if y == 0 {
            
            if x > 0 {
                direction = .Right
            } else if x < 0 {
                direction = .Left
            }
        } else if x == 0 {
            
            if y < 0 {
                direction = .Up
            } else if y > 0 {
                direction = .Down
            }
        } else if x != 0 && y != 0 {
            
            if x > 0 && y < 0 {
                direction =  .RUp
            } else if x > 0 && y > 0 {
                direction =  .RDown
            } else if x < 0 && y < 0 {
                direction =  .LUp
            } else if x < 0 && y > 0 {
                direction = .LDown
            }
        }
        return direction
    }
    
    
    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if scale > 1 {
            drawMesh(rect)
        }
    }
    
    private func drawMesh(_ rect: CGRect) {
        sectionWidth = ( rect.width - lineWidth * CGFloat(linesCount) ) / CGFloat(sectionsCount)
        
        let path = UIBezierPath()
        for i in 0..<linesCount {
            let offset = (sectionWidth + (sectionWidth + lineWidth) * CGFloat(i)) + (lineWidth / 2)
            drawLine(from: CGPoint(x: offset, y: 0),
                       to: CGPoint(x: offset, y: rect.height),
                       by: path)
            
            drawLine(from: CGPoint(x: 0, y: offset),
                     to: CGPoint(x: rect.width, y: offset),
                     by: path)
        }
        
        path.lineWidth = lineWidth
        UIColor.white.setFill()
        UIColor.black.setStroke()
        path.stroke()
    }

    private func drawLine(from startPoint: CGPoint, to endPoint: CGPoint, by path: UIBezierPath) {
        path.move(to: startPoint)
        path.addLine(to: endPoint)
    }
    
}
