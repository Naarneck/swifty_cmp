//
//  Histogram.swift
//  swiftycompanion2
//
//  Created by Ivan Zelenskyi on 11/16/18.
//  Copyright © 2018 Ivan Zelenskyi. All rights reserved.
//

import UIKit

class Histogram: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        drawBackground()
        print("Background init")
    }

    func drawBackground()
    {
        let center = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2)
        print(center)
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: self.bounds.width / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(shapeLayer)
    }
    
}
