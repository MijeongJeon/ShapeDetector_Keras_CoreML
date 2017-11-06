//
//  DrawingView.swift
//  ShapeDetector
//
//  Created by Mijeong Jeon on 30/10/2017.
//  Copyright © 2017 MijeonJeon. All rights reserved.
//

import UIKit

class Line {
    fileprivate var start: CGPoint
    fileprivate var end: CGPoint
    
    init(start _start: CGPoint, end _end: CGPoint) {
        start = _start
        end = _end
    }
}

class DrawingView: UIView {
    
    var lines: [Line] = []
    var lastPoint: CGPoint!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        for line in lines {
            context?.move(to: line.start)
            context?.addLine(to: line.end)
        }
        context?.setLineCap(CGLineCap.round)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setLineWidth(20.0)
        context?.strokePath()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      lastPoint = touches.first?.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let newPoint: CGPoint = touches.first?.location(in: self) else {
            return
        }
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        self.setNeedsDisplay()
    }
}
