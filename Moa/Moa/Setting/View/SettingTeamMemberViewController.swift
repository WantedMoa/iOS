//
//  SettingTeamMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import RxGesture

final class SettingTeamMemberViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var teamMemberCollectionView: UICollectionView!
    @IBOutlet private weak var dismissImageView: UIImageView!

    // ViewModel
    private lazy var input = SettingTeamMemberViewModel.Input()
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: SettingTeamMemberViewModel

    init() {
        self.viewModel = SettingTeamMemberViewModel()
        super.init(nibName: SettingTeamMemberViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    private func bind() {
        output.sections
            .drive(teamMemberCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        dismissImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        teamMemberCollectionView.rx.modelSelected(HomeBestMember.self)
            .subscribe { [weak self] (_: HomeBestMember) in
                guard let self = self else { return }
                let vc = SettingReviewTeamMemberViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareTeamMemberCollectionView()
    }
    
    private func prepareTeamMemberCollectionView() {
        teamMemberCollectionView.collectionViewLayout = generateLayout()
        teamMemberCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        teamMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
    }
}

// MAKR: - Generate CollectionView Layout
extension SettingTeamMemberViewController {
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
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitem: item,
                count: 1
            )
            group.contentInsets = NSDirectionalEdgeInsets.zero
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(23)
                ),
                subitems: [group, group, group, group]
            )
            horizontalGroup.interItemSpacing = .flexible(10)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.interGroupSpacing = 26
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
            return section
        }
        
        return layout
    }
}

extension SettingTeamMemberViewController {
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
        })
    }
}
