//
//  MoaTabBarController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

final class MoaTabBarController: UITabBarController {
    lazy var lineView: UIView = {
        let width = view.bounds.width
        let height = 0.5
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    private let childVCs: [UIViewController]
    
    init() {
        let homeVC = HomeViewController()
        let image = UIImage(named: "Home")
        homeVC.tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        childVCs = [homeVC]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers(childVCs, animated: false)
        tabBar.addSubview(lineView)
        tabBar.tintColor = .black
    }
}
