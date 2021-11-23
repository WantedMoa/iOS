//
//  MoaNavigationController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class MoaNavigationController: UINavigationController {
    lazy var lineView: UIView = {
        let width = view.bounds.width
        let height = 0.5
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        prepareNavigationBar()
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    var tintColor: UIColor {
        get {
            return navigationBar.tintColor
        }
        set(color) {
            navigationBar.tintColor = color
            let textAttributes = [NSAttributedString.Key.foregroundColor: color]
            navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    private func prepareNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.tintColor = .black
        
        let edgeInset = UIEdgeInsets(top: 25, left: -10, bottom: 0, right: 0)
        let image = UIImage(named: "BackButton")?.withAlignmentRectInsets(edgeInset)
        
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        
        let font = UIFont(name: "NotoSansKR-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: font],
            for: UIControl.State.normal
        )
    }
}

extension MoaNavigationController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
