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
    var skills : [Skill?] = [Skill(id: 0, name: "loading...", level: 0.0),Skill(id: 0, name: "loading...", level: 0.0)]
    
    func selectSkills(cursus: [CursusUser]){
        self.skills = cursus[0].skills
    }
    
    override func draw(_ rect: CGRect) {
        drawBackground()
        print("Background init")
    }
    
    func clear(){
        guard let layers = self.layer.sublayers else { return }
        for layer in layers {
            layer.removeFromSuperlayer()
        }
    }

    func drawBackground()
    {
//        let arr = [1.0, 2.2, 3.0, 4.0, 5.2, 6, 7.0, 8.0, 10.2, 21.0]
//        let arr_titles = ["asds", "23sad", "asdsd", "sadad", "asda ad ss", "ad22 3 adasd", "adssa add", "aadsds", "sdsd", "dsdsd"]
        clear()
        let center = CGPoint.init(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let radius = self.bounds.width / 4
        print(center)
        print(radius)
        
        for i in 1...7 {
            let shapeLayer = CAShapeLayer()
            let circularPath = UIBezierPath(arcCenter: center, radius: radius - CGFloat(CGFloat(i) * ((radius) / 6)) , startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            shapeLayer.path = circularPath.cgPath
            shapeLayer.strokeColor = UIColor.gray.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.fillColor = UIColor.white.cgColor
            self.layer.addSublayer(shapeLayer)
        }
        if self.skills.count <= 1 {
            return
        }
        let angle = 360.0 / Double(self.skills.count)
        let path = UIBezierPath()
        let linePath = UIBezierPath()
        for i in 0...self.skills.count - 1 {
            let x = Double(radius) * cos((angle * Double(i)) * Double.pi / 180.0) + Double(center.x)
            let y = Double(radius) * sin((angle * Double(i)) * Double.pi / 180.0) + Double(center.y)
            //draw lines
            linePath.move(to: center)
            linePath.addLine(to: CGPoint(x: x, y: y))
            //drawText
            let title = CATextLayer()
            title.string = (self.skills[i]?.name)! + " \(self.skills[i]?.level ?? 0.0)"
            title.isWrapped = true
            if (x >= Double(center.x))
            {
                title.frame = CGRect(x : x, y : y, width : (Double(UIScreen.main.bounds.width) - x), height : (Double(self.bounds.height) - y))
                title.alignmentMode = kCAAlignmentLeft
//                title.borderColor = UIColor.blue.cgColor
//                title.borderWidth = 1

            } else {
                title.frame = CGRect(x : 0, y : y, width : x, height : (Double(self.bounds.height) - y))
                title.alignmentMode = kCAAlignmentRight
//                title.borderColor = UIColor.blue.cgColor
//                title.borderWidth = 1
            }
            title.foregroundColor = UIColor.gray.cgColor
            title.fontSize = 11
            self.layer.addSublayer(title)
            
            
            //drawGraphic
            print(x , y)
            let currentPoint = CGPoint(x: x, y: y)
            var vecCurrentPoint = CGPoint(x: currentPoint.x - center.x , y: currentPoint.y - center.y)
            print(vecCurrentPoint)
            vecCurrentPoint.x = vecCurrentPoint.x * (CGFloat((self.skills[i]?.level)! / 21.0)) + center.x
            vecCurrentPoint.y = vecCurrentPoint.y * (CGFloat((self.skills[i]?.level)! / 21.0)) + center.y
            if i == 0 {
                path.move(to: vecCurrentPoint)
            } else {
                path.addLine(to: vecCurrentPoint)
                print(vecCurrentPoint)
            }
        }
        path.close()
        linePath.close()
        //add lines
        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.gray.cgColor
        lineLayer.lineWidth = 1
        lineLayer.path = linePath.cgPath
        self.layer.addSublayer(lineLayer)
        //add Graphic
        let graphLayer = CAShapeLayer()
        graphLayer.strokeColor = UIColor.cyan.cgColor
        graphLayer.fillColor = UIColor(white: 1, alpha: 0.5).cgColor
        graphLayer.lineWidth = 2
        graphLayer.path = path.cgPath
        self.layer.addSublayer(graphLayer)
    }
    func drawPath(){
    }
}
