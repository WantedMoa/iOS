//
//  CommunityJoinTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

final class CommunityJoinTeambuildViewController: UIViewController {
    var navVC: MoaNavigationController? {
        return navigationController as? MoaNavigationController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navVC?.tintColor = .black
    }
    
    private func configureUI() {
        navVC?.tintColor = .white
        navigationItem.title = "지원하기"
    }
}
