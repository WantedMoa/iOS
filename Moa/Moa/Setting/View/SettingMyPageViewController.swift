//
//  SettingMyPageViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class SettingMyPageViewController: UIViewController, IdentifierType {

    @IBOutlet private weak var myTeamBuildCollectionView: UICollectionView!
    @IBOutlet private weak var myTeamBuildLabel: UILabel!
    
    // ViewModel
    private lazy var input = SettingMyPageViewModel.Input(
        
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    
    // DI
    private let viewModel: SettingMyPageViewModel
    
    init() {
        self.viewModel = SettingMyPageViewModel()
        super.init(nibName: SettingMyPageViewController.identifier, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        prepareMyTeamBuildCollectionView()
    }
    
    private func bind() {
        output.myTeambuilds.drive(myTeamBuildCollectionView.rx.items(
            cellIdentifier: SettingMyTeambuildCell.identifier,
            cellType: SettingMyTeambuildCell.self)
        ) { _, item, cell in
            cell.titleLabel.text = item.0
            cell.subTitleLabel.text = item.1
        }
        .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        myTeamBuildLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = SettingDetailMyTeambuildViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        myTeamBuildCollectionView.rx.modelSelected((String, String).self)
            .subscribe { [weak self] (_: (String, String)) in
                guard let self = self else { return }
                let vc = SettingTeamMemberViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func prepareMyTeamBuildCollectionView() {
        myTeamBuildCollectionView.decelerationRate = .fast
        myTeamBuildCollectionView.delegate = self
        myTeamBuildCollectionView.register(
            UINib(nibName: SettingMyTeambuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: SettingMyTeambuildCell.identifier
        )
    }
}

extension SettingMyPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width: CGFloat = view.bounds.width * 0.8
        let heigth: CGFloat = 88
        return CGSize(width: width, height: heigth)
    }
    
    private func scrollItemToCenter(scrollView: UIScrollView) {
        let middlePoint = Int(scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
        let targetPoint = CGPoint(x: middlePoint, y: Int(myTeamBuildCollectionView.bounds.height) / 2)
        
        let indexPath = myTeamBuildCollectionView.indexPathForItem(at: targetPoint) ?? currentIndexPath
        currentIndexPath = indexPath
            
        myTeamBuildCollectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollItemToCenter(scrollView: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollItemToCenter(scrollView: scrollView)
    }
}
