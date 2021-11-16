//
//  BestMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class BestMemberViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var bestMemberCollectionView: UICollectionView!
    
    // ViewModel
    private lazy var input = BestMemberViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: BestMemberViewModel

    init() {
        self.viewModel = BestMemberViewModel()
        super.init(nibName: BestMemberViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        output.sections
            .drive(bestMemberCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "인기팀원"
        prepareBestMemberCollectionView()
    }
    
    private func prepareBestMemberCollectionView() {
        bestMemberCollectionView.collectionViewLayout = generateLayout()
        bestMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
        bestMemberCollectionView.register(
            UINib(nibName: HomeBestMemberReusableView.identifier, bundle: nil),
            forSupplementaryViewOfKind: HomeBestMemberReusableView.headerElementKind,
            withReuseIdentifier: HomeBestMemberReusableView.identifier
        )
    }
}

// MAKR: - Generate CollectionView Layout
extension BestMemberViewController {
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
              widthDimension: .absolute(76),
              heightDimension: .absolute(100)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            let headerSize = NSCollectionLayoutSize(
              widthDimension: .fractionalWidth(1.0),
              heightDimension: .estimated(23))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
              layoutSize: headerSize,
              elementKind: HomeBestMemberReusableView.headerElementKind,
              alignment: .top
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 26
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
                
        return layout
    }
}

extension BestMemberViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<BestMemberSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell: {
            dataSource, collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeBestMemberCell.identifier,
                for: indexPath
            ) as? HomeBestMemberCell else {
                return UICollectionViewCell()
            }
            
            cell.update(by: dataSource[indexPath], isHiddenStatus: false)
            return cell
        }, configureSupplementaryView: {
            [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            guard let reuseView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeBestMemberReusableView.identifier,
                for: indexPath
            ) as? HomeBestMemberReusableView
            else {
                return UICollectionReusableView()
            }
            
            let title = self.viewModel.sectionTitles[indexPath.section]
            reuseView.update(by: title)
            return reuseView
        })
    }
}
