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
    duration: CFTimeInterval,
    isHiddenLayer: Bool
)

final class MatchViewController: UIViewController, UnderLineNavBar {
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileView: UIView!

    private let innerFirstProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.image = UIImage(named: "TestProfile1")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    private let innerMatchCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+14"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var innerMatchCountView: UIView = {
        let countView = UIView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        countView.backgroundColor = .black
        countView.layer.masksToBounds = true
        countView.layer.cornerRadius = 54 / 2
        countView.addSubview(innerMatchCountLabel)
        NSLayoutConstraint.activate([
            innerMatchCountLabel.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
            innerMatchCountLabel.centerYAnchor.constraint(equalTo: countView.centerYAnchor)
        ])
        return countView
    }()
    
    private let outterFirstProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        imageView.image = UIImage(named: "TestProfile2")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 54 / 2
        return imageView
    }()
    
    private let outterSecondProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        imageView.image = UIImage(named: "TestProfile3")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 42 / 2
        return imageView
    }()
    
    private let outterThirdProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        imageView.image = UIImage(named: "TestProfile4")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 54 / 2
        return imageView
    }()
    
    private var isFirstLoaded = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func test() {
        let contents: [MatchCircleContent] = [
            (view: UIView(), radius: 128 / 2, startAngle: 90, duration: 0, isHiddenLayer: false),
            (view: innerFirstProfileImageView, radius: 234 / 2, startAngle: 225, duration: 9, isHiddenLayer: false),
            (view: innerMatchCountView, radius: 234 / 2, startAngle: 45, duration: 9, isHiddenLayer: true),
            (view: outterFirstProfileImageView, radius: 336 / 2, startAngle: -30, duration: 9, isHiddenLayer: false),
            (view: outterSecondProfileImageView, radius: 336 / 2, startAngle: 180, duration: 9, isHiddenLayer: true),
            (view: outterThirdProfileImageView, radius: 336 / 2, startAngle: 95, duration: 9, isHiddenLayer: true)
        ]
        
        if isFirstLoaded {
            for content in contents {
                animateCirlePath(
                    contentView: content.view,
                    circlePathRadius: content.radius,
                    circlePathStartAngle: content.startAngle,
                    animationDuration: content.duration,
                    isHideLayer: content.isHiddenLayer
                )
            }
            
            isFirstLoaded = false
        }
    }
    
    private func configureUI() {
        navigationItem.title = "팀원 매칭"
        addUnderLineOnNavBar()
        prepareProfileImageView()
        prepareProfileView()
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 74 / 2
    }
    
    private func prepareProfileView() {
        profileView.backgroundColor = .clear
        profileView.clipsToBounds = false
        profileView.layer.shadowColor = UIColor.black.cgColor
        profileView.layer.shadowOpacity = 0.3
        profileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        profileView.layer.shadowRadius = 74 / 2
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
