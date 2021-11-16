//
//  BestTeamBuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class HomeBestTeamBuildViewController: UIViewController, IdentifierType {
    // MARK: - IBOutlet
    @IBOutlet private weak var bestTeamBuildCollectionView: UICollectionView!
    
    // ViewModel
    private lazy var input = HomeBestTeamBuildViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: HomeBestTeamBuildViewModel

    init() {
        self.viewModel = HomeBestTeamBuildViewModel()
        super.init(nibName: HomeBestTeamBuildViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        output.teamBuildes.drive(bestTeamBuildCollectionView.rx.items(
            cellIdentifier: HomeDetailBestTeamBuildCell.identifier,
            cellType: HomeDetailBestTeamBuildCell.self)
        ) { _, _, _ in
            
        }
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "인기 팀원 모집 공고"
        prepareBestTeamBuildCollectionView()
    }
    
    private func prepareBestTeamBuildCollectionView() {
        bestTeamBuildCollectionView.delegate = self
        bestTeamBuildCollectionView.register(
            UINib(nibName: HomeDetailBestTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeDetailBestTeamBuildCell.identifier
        )
    }
}

extension HomeBestTeamBuildViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.bounds.width - 12 - 16 * 2) / 2
        let height = width * 1.83
        return CGSize(width: width, height: height)
    }
}
