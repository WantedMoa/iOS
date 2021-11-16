//
//  BestTeamBuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class BestTeamBuildViewController: UIViewController {
    // MARK: - IBOutlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureUI() {
        navigationItem.title = "인기 팀원 모집 공고"
    }
}
