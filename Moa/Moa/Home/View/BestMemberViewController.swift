//
//  BestMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class BestMemberViewController: UIViewController {
    @IBOutlet private weak var bestMemberCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func configureUI() {
        navigationItem.title = "인기팀원"
        prepareBestMemberCollectionView()
    }
    
    private func prepareBestMemberCollectionView() {
        bestMemberCollectionView.collectionViewLayout = generateLayout()
    }
}

// MAKR: - CollectionView Layout
extension BestMemberViewController {
    func generateLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(1),
                heightDimension: .estimated(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
              widthDimension: .absolute(76),
              heightDimension: .absolute(100)
            )
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16)
            
//            let headerSize = NSCollectionLayoutSize(
//              widthDimension: .fractionalWidth(1.0),
//              heightDimension: .estimated(44))
//            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
//              layoutSize: headerSize,
//              elementKind: AlbumsViewController.sectionHeaderElementKind,
//              alignment: .top)

            let section = NSCollectionLayoutSection(group: group)
            // section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
}
