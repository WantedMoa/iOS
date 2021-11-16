//
//  MatchViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit
import SwiftUI

typealias MatchCircleContent = (
    view: UIView,
    radius: CGFloat,
    startAngle: Double,
    duration: CFTimeInterval
)

final class MatchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let contents: [MatchCircleContent] = [
            (view: generateTestView(), radius: 64, startAngle: 90, duration: 10),
            (view: generateTestView(), radius: 100, startAngle: 0, duration: 10),
            (view: generateTestView(), radius: 120, startAngle: 180, duration: 10),
            (view: generateTestView(), radius: 140, startAngle: 250, duration: 10)
        ]
        
        for content in contents {
            animateCirlePath(
                contentView: content.view,
                circlePathRadius: content.radius,
                circlePathStartAngle: content.startAngle,
                animationDuration: content.duration
            )
        }
    }
}

// MAKR: - AnimateCirlePath
extension MatchViewController {
    private func generateTestView() -> UIView {
        let squareView = UIView()
        squareView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        squareView.backgroundColor = .lightGray
        return squareView
    }
    
    private func animateCirlePath(
        contentView target: UIView,
        circlePathRadius radius: Double,
        circlePathStartAngle startAngle: Double,
        animationDuration duration: CFTimeInterval
    ) {
        let circlePath = UIBezierPath(
            arcCenter: view.center,
            radius: radius,
            startAngle: Angle(degrees: startAngle).radians,
            endAngle: Angle(degrees: startAngle + 360).radians,
            clockwise: true
        )
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 10
        animation.repeatCount = MAXFLOAT
        animation.path = circlePath.cgPath
        animation.isRemovedOnCompletion = false

        view.addSubview(target)
        target.layer.add(animation, forKey: nil)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = 2
        circleLayer.strokeColor = UIColor(rgb: 0xdddddd).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineDashPattern = [4, 4]
        view.layer.addSublayer(circleLayer)
    }
}
