//
//  SettingDetailMyTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class SettingDetailMyTeambuildViewController: UIViewController, UnderLineNavBar {
    @IBOutlet private weak var myTeamBuildCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        Driver.of(["A"])
            .drive(myTeamBuildCollectionView.rx.items(
                cellIdentifier: SettingDetailMyTeambuildCell.identifier,
                cellType: SettingDetailMyTeambuildCell.self)
            ) { _, item, cell in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "나의 팀"
        addUnderLineOnNavBar()
        prepareMyTeambuildCollectionView()
    }
    
    private func prepareMyTeambuildCollectionView() {
        myTeamBuildCollectionView.delegate = self
        myTeamBuildCollectionView.register(
            UINib(nibName: SettingDetailMyTeambuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: SettingDetailMyTeambuildCell.identifier
        )
    }
}

extension SettingDetailMyTeambuildViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = view.bounds.width - 16 * 2
        let heigth: CGFloat = 237
        return CGSize(width: width, height: heigth)
    }
}
