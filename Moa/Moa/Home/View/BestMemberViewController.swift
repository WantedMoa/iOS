//
//  BestMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class BestMemberViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "인기팀원"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
