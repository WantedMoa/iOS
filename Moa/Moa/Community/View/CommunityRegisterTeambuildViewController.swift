//
//  CommunityRegisterTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

final class CommunityRegisterTeambuildViewController: UIViewController, UnderLineNavBar {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        navigationItem.title = "팀원 모집하기"
        addUnderLineOnNavBar()
    }
    
}
