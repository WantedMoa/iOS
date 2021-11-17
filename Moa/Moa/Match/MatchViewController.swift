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
    
    private var isFirstLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoaded {
            let contents: [MatchCircleContent] = [
                (view: UIView(), radius: 128 / 2, startAngle: 90, duration: 0),
                (view: generateImageView(32), radius: 234 / 2, startAngle: 100, duration: 5),
                (view: generateImageView(42), radius: 336 / 2, startAngle: 150, duration: 5),
                (view: generateImageView(54), radius: 336 / 2, startAngle: 30, duration: 5),
                (view: generateImageView(54), radius: 336 / 2, startAngle: 270, duration: 5)
            ]
            
            for (index, content) in contents.enumerated() {
                animateCirlePath(
                    contentView: content.view,
                    circlePathRadius: content.radius,
                    circlePathStartAngle: content.startAngle,
                    animationDuration: content.duration,
                    isHideLayer: index < 3 ? false : true
                )
            }
            
            isFirstLoaded = false
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
    
    private func generateImageView(_ width: CGFloat) -> UIImageView {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: width)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = width / 2
        imageView.image = UIImage(named: "TestProfile1")
        return imageView
    }
    
    private func animateCirlePath(
        contentView target: UIView,
        circlePathRadius radius: Double,
        circlePathStartAngle startAngle: Double,
        animationDuration duration: CFTimeInterval,
        isHideLayer: Bool = false
    ) {
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: Angle(degrees: startAngle).radians,
            endAngle: Angle(degrees: startAngle + 360).radians,
            clockwise: true
        )
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = duration
        animation.repeatCount = 0 // MAXFLOAT
        animation.path = circlePath.cgPath
        animation.isRemovedOnCompletion = false
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = isHideLayer == false ? 2 : 0
        circleLayer.strokeColor = UIColor(rgb: 0xdddddd).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineDashPattern = [4, 4]
        
        target.frame = CGRect(
            x: circlePath.currentPoint.x - (target.bounds.width / 2),
            y: circlePath.currentPoint.y - (target.bounds.height / 2),
            width: target.bounds.width,
            height: target.bounds.height
        )
        
        view.layer.addSublayer(circleLayer)
        view.addSubview(target)
        target.layer.add(animation, forKey: nil)
    }
}
