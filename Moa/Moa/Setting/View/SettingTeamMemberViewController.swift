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

final class SettingTeamMemberViewController: UIViewController, IdentifierType, UnderLineNavBar {
    @IBOutlet private weak var teamMemberCollectionView: UICollectionView!
    @IBOutlet private weak var teamMemberCollectionViewHeightLayout: NSLayoutConstraint!
    @IBOutlet private weak var teamView: UIView!
    
    // ViewModel
//    private lazy var input = SettingTeamMemberViewModel.Input(
//        fetchSections: fetchSections.asSignal()
//    )
//    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    // private let fetchSections = PublishRelay<Void>()
    
    // DI
    // private let viewModel: SettingTeamMemberViewModel
    
    private let sections: Driver<[BestMemberSectionModel]>
    private let team: SettingMyTeam

    init(team: SettingMyTeam) {
        // self.viewModel = SettingTeamMemberViewModel(index: index)
        self.team = team
        
        let users = team.member.map {
            HomePopularUsersDetail.init(index: $0.userIdx, profileImageURL: $0.profileImg, name: $0.name)
        }
        
        self.sections = Driver<[BestMemberSectionModel]>.of([
            .marketer(items: users)
        ])
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
        
        // fetchSections.accept(())
    }
    
    private func bind() {
        sections
            .drive(teamMemberCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
        sections
            .compactMap { $0.first?.items.count }
            .drive { [weak self] (count: Int) in
                guard let self = self else { return }
                let empty = count % 4
                let line = count / 4 + (empty == 0 ? 0 : 1)
                let height = CGFloat(30 + 110 * line)
                self.teamMemberCollectionViewHeightLayout.constant = height
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
//        teamMemberCollectionView.rx.modelSelected(HomeBestMember.self)
//            .subscribe { [weak self] (_: HomeBestMember) in
//                guard let self = self else { return }
//                let vc = SettingReviewTeamMemberViewController()
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
//            }
//            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "나의 팀"
        addUnderLineOnNavBar()
        prepareTeamMemberCollectionView()
        prepareTeamView()
    }
    
    private func prepareTeamMemberCollectionView() {
        teamMemberCollectionView.collectionViewLayout = generateLayout()
        teamMemberCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        teamMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
    }
    
    private func prepareTeamView() {
        teamView.layer.masksToBounds = false
        teamView.layer.cornerRadius = 10
        teamView.layer.shadowColor = UIColor.black.cgColor
        teamView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        teamView.layer.shadowOpacity = 0.15
        teamView.layer.shadowRadius = 4.0
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
            horizontalGroup.interItemSpacing = .flexible(0)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.interGroupSpacing = 20
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 10, leading: 10, bottom: 5, trailing: 10)
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
