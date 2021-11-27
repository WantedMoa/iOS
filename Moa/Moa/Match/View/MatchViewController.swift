//
//  MatchViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import SwiftUI
import UIKit

import RxCocoa
import RxGesture
import RxSwift
import Kingfisher

struct MatchCircleContent {
    let view: UIView
    let radius: CGFloat
    let startAngle: Double
    let duration: CFTimeInterval
    let isHiddenLayer: Bool
}

final class MatchViewController: UIViewController, IdentifierType, UnderLineNavBar {
    // MARK: - IBOutlet
    // Profile
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileView: UIView!
    // MyTeamBuild
    @IBOutlet private weak var myTeamBuildCollectionView: UICollectionView!
    @IBOutlet private weak var myTeamTitleLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    /// innerFirstProfileView
    private let innerFirstProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.image = UIImage(named: "TestProfile9")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 32 / 2
        return imageView
    }()
    
    private lazy var innerFirstProfileView: UIView = {
        let contentView = generateShadowView(cgRect: innerFirstProfileImageView.frame, radius: 32 / 2)
        contentView.addSubview(innerFirstProfileImageView)
        return contentView
    }()
    
    /// innerMatchCountView
    private let innerMatchCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+14"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var innerMatchCountView: UIView = {
        let countView = UIView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        countView.backgroundColor = .black
        countView.layer.masksToBounds = true
        countView.layer.cornerRadius = 54 / 2
        countView.addSubview(innerMatchCountLabel)
        NSLayoutConstraint.activate([
            innerMatchCountLabel.centerXAnchor.constraint(equalTo: countView.centerXAnchor),
            innerMatchCountLabel.centerYAnchor.constraint(equalTo: countView.centerYAnchor)
        ])
        return countView
    }()
    
    /// outterFirstProfileView
    private let outterFirstProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        imageView.image = UIImage(named: "TestProfile2")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 54 / 2
        return imageView
    }()
    
    private lazy var outterFirstProfileView: UIView = {
        let contentView = generateShadowView(cgRect: outterFirstProfileImageView.frame, radius: 54 / 2)
        contentView.addSubview(outterFirstProfileImageView)
        return contentView
    }()
    
    /// outterSecondProfileView
    private let outterSecondProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        imageView.image = UIImage(named: "TestProfile3")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 42 / 2
        return imageView
    }()
    
    private lazy var outterSecondProfileView: UIView = {
        let contentView = generateShadowView(cgRect: outterSecondProfileImageView.frame, radius: 42 / 2)
        contentView.addSubview(outterSecondProfileImageView)
        return contentView
    }()
    
    /// outterThirdProfileView
    private let outterThirdProfileImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        imageView.image = UIImage(named: "TestProfile4")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 54 / 2
        return imageView
    }()
        
    private lazy var outterThirdProfileView: UIView = {
        let contentView = generateShadowView(cgRect: outterThirdProfileImageView.frame, radius: 54 / 2)
        contentView.addSubview(outterThirdProfileImageView)
        return contentView
    }()
    
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    private var isFirstLoaded = true

    // ViewModel
    private lazy var input = MatchViewModel.Input(
        fetchMyTeambuilds: fetchMyTeambuilds.asSignal(),
        fetchRecommends: fetchRecommends.asSignal(),
        fetchUserProfile: fetchUserProfile.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let fetchMyTeambuilds = PublishRelay<Void>()
    private let fetchRecommends = PublishRelay<Int>()
    private let fetchUserProfile = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: MatchViewModel
    
    init() {
        self.viewModel = MatchViewModel()
        super.init(nibName: MatchViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        
        fetchUserProfile.accept(())
        fetchMyTeambuilds.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateContents()
    }
    
    private func bind() {
        output.myTeambuilds.drive(myTeamBuildCollectionView.rx.items(
            cellIdentifier: MatchMyTeamBuildCell.identifier,
            cellType: MatchMyTeamBuildCell.self)
        ) { _, item, cell in
            cell.update(by: item)
        }
        .disposed(by: disposeBag)
        
        output.myTeamTitle.drive(myTeamTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.recommendCount
            .map { "+\($0)" }
            .drive(innerMatchCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.innerImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] url in
                guard let self = self else { return }
                self.innerFirstProfileImageView.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
        
        output.outerFirstImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] url in
                guard let self = self else { return }
                self.outterFirstProfileImageView.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
        
        output.outerSecondImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] url in
                guard let self = self else { return }
                self.outterSecondProfileImageView.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
        
        output.outerThirdImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] url in
                guard let self = self else { return }
                self.outterThirdProfileImageView.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
        
        output.profileImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] (url: String) in
                guard let self = self else { return }
                self.profileImageView.kf.setImage(with: URL(string: url))
            }
            .disposed(by: disposeBag)
        
        output.name.drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        innerMatchCountView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (tapGesture: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = HomeBestMemberViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "팀원 매칭"
        addUnderLineOnNavBar()
        prepareProfileImageView()
        prepareProfileView()
        prepareMyTeamBuildCollectionView()
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 74 / 2
    }
    
    private func prepareProfileView() {
        profileView.backgroundColor = .clear
        profileView.layer.masksToBounds = false
        profileView.layer.cornerRadius = 83 / 2
        profileView.layer.shadowOffset = .zero
        profileView.layer.shadowRadius = 5
        profileView.layer.shadowOpacity = 0.3
    }
    
    private func prepareMyTeamBuildCollectionView() {
        myTeamBuildCollectionView.decelerationRate = .fast
        myTeamBuildCollectionView.delegate = self
        myTeamBuildCollectionView.register(
            UINib(nibName: MatchMyTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: MatchMyTeamBuildCell.identifier
        )
    }
}

// MAKR: - AnimateCirlePath
extension MatchViewController {
    private func animateContents() {
        if isFirstLoaded {
            for content in generateCircleContents() {
                animateCirlePath(
                    contentView: content.view,
                    circlePathRadius: content.radius,
                    circlePathStartAngle: content.startAngle,
                    animationDuration: content.duration,
                    isHideLayer: content.isHiddenLayer
                )
            }
            
            isFirstLoaded = false
        }
    }
    
    private func animateCirlePath(
        contentView target: UIView,
        circlePathRadius radius: Double,
        circlePathStartAngle startAngle: Double,
        animationDuration duration: CFTimeInterval,
        isHideLayer: Bool = false
    ) {
        let center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: Angle(degrees: startAngle).radians,
            endAngle: Angle(degrees: startAngle + 360).radians,
            clockwise: true
        )
        
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = duration
        animation.repeatCount = 0 // MAXFLOAT
        animation.path = circlePath.cgPath
        animation.isRemovedOnCompletion = false // 사용자가 멈추기 가능
        animation.fillMode = .forwards
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.lineWidth = isHideLayer == false ? 2 : 0
        circleLayer.strokeColor = UIColor(rgb: 0xdddddd).cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineDashPattern = [4, 4]
        
        let countDown = duration * 11
        view.layer.addSublayer(circleLayer)
        view.addSubview(target)
        target.layer.add(animation, forKey: nil)
        
        _ = Observable<Int>
            .timer(.milliseconds(0), period: .milliseconds(100), scheduler: MainScheduler.instance)
            .take(Int(countDown) + 1)
            .subscribe { (_: Int) in
                if let location = target.layer.presentation()?.frame {
                    target.frame = CGRect(
                        x: location.origin.x,
                        y: location.origin.y,
                        width: location.size.width,
                        height: location.size.height
                    )
                }
            }
    }
    
    private func generateCircleContents() -> [MatchCircleContent] {
        let duration: CGFloat = 6
        
        let contents = [
            MatchCircleContent(
                view: UIView(),
                radius: 128 / 2,
                startAngle: 90,
                duration: 0,
                isHiddenLayer: false
            ),
            MatchCircleContent(
                view: innerFirstProfileView,
                radius: 210 / 2,
                startAngle: 225,
                duration: duration,
                isHiddenLayer: false
            ),
            MatchCircleContent(
                view: innerMatchCountView,
                radius: 210 / 2,
                startAngle: 45,
                duration: duration,
                isHiddenLayer: true
            ),
            MatchCircleContent(
                view: outterFirstProfileView,
                radius: 310 / 2,
                startAngle: -30,
                duration: duration,
                isHiddenLayer: false
            ),
            MatchCircleContent(
                view: outterSecondProfileView,
                radius: 310 / 2,
                startAngle: 180,
                duration: duration,
                isHiddenLayer: true
            ),
            MatchCircleContent(
                view: outterThirdProfileView,
                radius: 310 / 2,
                startAngle: 95,
                duration: duration,
                isHiddenLayer: true
            )
        ]
        
        return contents
    }
    
    private func generateShadowView(cgRect: CGRect, radius: CGFloat) -> UIView {
        let backgroundView = UIView(frame: cgRect)
        backgroundView.backgroundColor = .clear
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.cornerRadius = radius
        backgroundView.layer.shadowOffset = .zero
        backgroundView.layer.shadowRadius = 5
        backgroundView.layer.shadowOpacity = 0.25
        return backgroundView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MatchViewController: UICollectionViewDelegateFlowLayout {
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
        
        let item = viewModel.myTeambuilds.value[indexPath.item]
        let title = item.title
        myTeamTitleLabel.text = title
        fetchRecommends.accept(item.index)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollItemToCenter(scrollView: scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollItemToCenter(scrollView: scrollView)
    }
}
