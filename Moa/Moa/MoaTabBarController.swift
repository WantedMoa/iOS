//
//  MoaTabBarController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

enum MoaTab: String, CaseIterable {
    case home = "Home"
    case community = "Community"
    case match = "Match"
    case setting = "Setting"
}

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
        let communityVC = CommunityViewController()
        let matchVC = MatchViewController()
        let settingVC = SettingViewController()
        
        childVCs = [
            MoaNavigationController(rootViewController: homeVC),
            communityVC,
            matchVC,
            settingVC
        ]
        
        let imageInset = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        
        for (childVC, tab) in zip(childVCs, MoaTab.allCases) {
            var vc = childVC
            
            if let navVC = childVC as? UINavigationController,
               let firstVC = navVC.viewControllers.first {
                vc = firstVC
            }
            
            let image = UIImage(named: tab.rawValue)
            vc.tabBarItem = UITabBarItem(title: nil, image: image, tag: 0)
            vc.tabBarItem.imageInsets = imageInset
        }

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
