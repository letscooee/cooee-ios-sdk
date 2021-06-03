//
//  CircularProgressView.swift
//  shaadicardmaker
//
//  Created by Surbhi Lath on 06/08/20.
//  Copyright © 2020 codenicely. All rights reserved.
//

import UIKit

class CircularProgressView: UIView {
   
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    var previousProgress:Double = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 10, startAngle: -.pi / 2, endAngle: 3 * .pi / 2, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 4.0
        circleLayer.strokeColor = UIColor.yellow.cgColor
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = #colorLiteral(red: 0.8431372549, green: 0.8431372549, blue: 0.8431372549, alpha: 1)
        layer.addSublayer(circleLayer)
        layer.addSublayer(progressLayer)
    }
   
    func progressAnimation(duration: TimeInterval, value: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.fromValue = previousProgress
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
        previousProgress = value
    }
}


class AnimatedRingView: UIView {
    private static let animationDuration = CFTimeInterval(10)
    private let π = CGFloat.pi
    private let startAngle = 1.5 * CGFloat.pi
    private let strokeWidth = CGFloat(3)
    var proportion = CGFloat(0.5) {
        didSet {
            setNeedsLayout()
        }
    }

    private lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.strokeColor = UIColor.yellow.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = self.strokeWidth
        self.layer.addSublayer(circleLayer)
        return circleLayer
    }()

    private lazy var ringlayer: CAShapeLayer = {
        let ringlayer = CAShapeLayer()
        ringlayer.fillColor = UIColor.clear.cgColor
        ringlayer.strokeColor = self.tintColor.cgColor
        ringlayer.lineCap = CAShapeLayerLineCap.round
        ringlayer.lineWidth = self.strokeWidth
        self.layer.addSublayer(ringlayer)
        return ringlayer
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = (min(frame.size.width, frame.size.height) - strokeWidth - 2)/2
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: startAngle + 2 * π, clockwise: true)
        circleLayer.path = circlePath.cgPath
        ringlayer.path = circlePath.cgPath
        ringlayer.strokeEnd = proportion
    }

    func animateRing(From startProportion: CGFloat, To endProportion: CGFloat, Duration duration: CFTimeInterval = animationDuration) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = startProportion
        animation.toValue = endProportion
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        ringlayer.strokeEnd = endProportion
        ringlayer.strokeStart = startProportion
        ringlayer.add(animation, forKey: "animateRing")
    }

}
