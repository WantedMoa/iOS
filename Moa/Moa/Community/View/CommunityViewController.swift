//
//  CommunityViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class CommunityViewController: UIViewController, IdentifierType, UnderLineNavBar {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var teambuildCollectionView: UICollectionView!
    
    // ViewModel
    private lazy var input = CommunityViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: CommunityViewModel
    
    init() {
        self.viewModel = CommunityViewModel()
        super.init(nibName: CommunityViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func bind() {
        output.teambuilds.drive(teambuildCollectionView.rx.items(
            cellIdentifier: CommunityTeamBuildCell.identifier,
            cellType: CommunityTeamBuildCell.self)
        ) { _, _, _ in
            
        }
        .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "커뮤니티"
        addUnderLineOnNavBar()
        prepareSearchBar()
        prepareTeambuildCollectionView()
    }
    
    private func prepareSearchBar() {
        searchBar.backgroundImage = UIImage()
    }
    
    private func prepareTeambuildCollectionView() {
        teambuildCollectionView.delegate = self
        teambuildCollectionView.register(
            UINib(nibName: CommunityTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: CommunityTeamBuildCell.identifier
        )
    }
}

extension CommunityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = view.bounds.width - (15 * 2)
        let height: CGFloat = 94
        return CGSize(width: width, height: height)
    }
}
