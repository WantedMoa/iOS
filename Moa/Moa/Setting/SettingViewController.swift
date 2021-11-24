//
//  SettingViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

enum SettingTab: Int {
    case myPage
    case profile
}

final class SettingViewController: UIViewController, UnderLineNavBar {
    @IBOutlet private weak var myPageLabel: UILabel!
    @IBOutlet private weak var profileLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var contentView: UIView!
    
    private lazy var selectedBottomLine: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 44, width: 0, height: 2))
        view.backgroundColor = .black
        return view
    }()
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
    
    private let disposeBag = DisposeBag()
    private var pages: [UIViewController] = []

    private var halfViewWidth: CGFloat {
        return view.bounds.width / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if selectedBottomLine.bounds.width < halfViewWidth {
            selectedBottomLine.frame = CGRect(x: 0, y: 44, width: halfViewWidth, height: 2)
        }
    }
    
    private func bindUI() {
        myPageLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let index = SettingTab.myPage.rawValue
                self.animateBottomLine(index: index)
                self.setPageController(scrollToIndex: index)
            }
            .disposed(by: disposeBag)
        
        profileLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let index = SettingTab.profile.rawValue
                self.animateBottomLine(index: index)
                self.setPageController(scrollToIndex: index)
            }
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        navigationItem.title = "설정"
        headerView.addSubview(selectedBottomLine)
        addUnderLineOnNavBar()
        preparePageViewController()
    }
    
    private func animateBottomLine(index: Int) {
        let locationX: CGFloat = index == 0 ? 0 : halfViewWidth
        let isMyPageSelect = index == 0
        
        myPageLabel.font = isMyPageSelect ? .notoSansMedium(size: 16) : .notoSansRegular(size: 16)
        profileLabel.font = !isMyPageSelect ? .notoSansMedium(size: 16) : .notoSansRegular(size: 16)
        
        UIView.animate(withDuration: 0.15) {
            let location = CGRect(x: locationX, y: 44, width: self.halfViewWidth, height: 2)
            self.selectedBottomLine.frame = location
        }
    }
    
    private func setPageController(scrollToIndex index: Int) {
        let isFirstItem = index == 0
        let direction: UIPageViewController.NavigationDirection = isFirstItem ? .reverse : .forward
        
        pageViewController.setViewControllers(
            [pages[index]],
            direction: direction,
            animated: true
        )
    }
    
    private func preparePageViewController() {
        let myPageVC = SettingMyPageViewController()
        let profileVC = SettingProfileViewController()
        pages = [myPageVC, profileVC]
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([profileVC], direction: .forward, animated: true)
        pageViewController.setViewControllers([myPageVC], direction: .forward, animated: true)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        contentView.addSubview(pageViewController.view)
        constaintPageViewControllerView()
    }
    
    private func constaintPageViewControllerView() {
        let pageContentView: UIView = pageViewController.view
        pageContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pageContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pageContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pageContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension SettingViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        guard index == 1 else { return nil }
        
        let prevIndex = index - 1
        return pages[prevIndex]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil }
        guard index == 0 else { return nil }
        
        let nextIndex = index + 1
        return pages[nextIndex]
    }
}

extension SettingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let index = pages.lastIndex(of: currentVC) else { return }
        animateBottomLine(index: index)
    }
}

