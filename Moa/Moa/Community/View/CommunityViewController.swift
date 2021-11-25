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
    // MARK: - IBOutlet
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var teambuildCollectionView: UICollectionView!
    @IBOutlet private weak var teambuildCollectionHeightLayout: NSLayoutConstraint!
    @IBOutlet private weak var addButtonView: UIView!
    
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
        bindUI()
        bind()
        updateTagStackView(by: ["Figma", "인공지능", "해커톤", "기획능력", "UX/UI"])
    }
    
    private func bind() {
        output.teambuilds
            .drive(teambuildCollectionView.rx.items(
                cellIdentifier: CommunityTeamBuildCell.identifier,
                cellType: CommunityTeamBuildCell.self)
            ) { _, item, cell in
                cell.update(data: item)
            }
            .disposed(by: disposeBag)
        
        output.teambuilds
            .drive { [weak self] (teambuilds: [TestbestMembers]) in
                guard let self = self else { return }
                let height = CGFloat(30 + teambuilds.count * 110)
                self.teambuildCollectionHeightLayout.constant = height
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        teambuildCollectionView.rx.modelSelected(TestbestMembers.self)
            .subscribe { [weak self] (model: TestbestMembers) in
                guard let self = self else { return }
                let vc = CommunityJoinTeambuildViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        addButtonView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = CommunityRegisterTeambuildViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "커뮤니티"
        addUnderLineOnNavBar()
        prepareSearchBar()
        prepareTeambuildCollectionView()
        prepareAddButtonView()
    }
    
    private func prepareSearchBar() {
        let font = UIFont(name: "NotoSansKR-Regular", size: 13) ?? .systemFont(ofSize: 15)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]
        
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        searchBar.backgroundImage = UIImage()
        searchBar.setImage(UIImage(named: "MoaSearch"), for: .search, state: .normal)
        searchBar[keyPath: \.searchTextField].font = font
        searchBar[keyPath: \.searchTextField].attributedPlaceholder = NSAttributedString(
            string: "공모전/팀원 이름, 기술스택/파트를 검색할 수 있어요",
            attributes:attributes
        )
    }
    
    private func prepareTeambuildCollectionView() {
        teambuildCollectionView.delegate = self
        teambuildCollectionView.register(
            UINib(nibName: CommunityTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: CommunityTeamBuildCell.identifier
        )
    }
    
    private func prepareAddButtonView() {
        addButtonView.layer.masksToBounds = true
        addButtonView.layer.cornerRadius = 66 / 2
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

// MARK: - TagStackView
extension CommunityViewController {
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel()
            label.text = "#" + tag
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel() -> UILabel {
        let font = UIFont(name: "NotoSansKR-Normal", size: 11) ?? UIFont.systemFont(ofSize: 11)
        let label = UILabel()
        label.font = font
        label.textColor = UIColor(rgb: 0xb8b8b8)
        return label
    }
}
