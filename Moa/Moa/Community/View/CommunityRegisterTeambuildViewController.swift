//
//  CommunityRegisterTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

typealias PickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
typealias MoaSupport = UnderLineNavBar & CustomAlert & IdentifierType

final class CommunityRegisterTeambuildViewController: UIViewController, MoaSupport {
    @IBOutlet private weak var photoSelectView: UIView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var competitionTitleTextField: UITextField!
    @IBOutlet private weak var teambuildContentTextView: UITextView!
    @IBOutlet private weak var teambuildContentPlaceholderLabel: UILabel!
    
    // Tag
    @IBOutlet private weak var tagStackView: UIStackView!
    
    // Date
    @IBOutlet private weak var teambuildEndDateStackView: UIStackView!
    @IBOutlet private weak var teambuildEndDateLabel: UILabel!
    @IBOutlet private weak var competitionStartDateStackView: UIStackView!
    @IBOutlet private weak var competitionStartDateLabel: UILabel!
    @IBOutlet private weak var competitionEndDateStackView: UIStackView!
    @IBOutlet private weak var competitionEndDateLabel: UILabel!
    
    private lazy var imagePicker: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        return vc
    }()
    
    // ViewModel
    private lazy var input = CommunityRegisterTeambuildViewModel.Input(
        changeTeambuildEndDate: changeTeambuildEndDate.asSignal(),
        changeCompetitionStartDate: changeCompetitionStartDate.asSignal(),
        changeCompetitionEndDate: changeCompetitionEndDate.asSignal(),
        addTag: addTag.asSignal(),
        removeTag: removeTag.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    // Event
    private let changeTeambuildEndDate = PublishRelay<Date>()
    private let changeCompetitionStartDate = PublishRelay<Date>()
    private let changeCompetitionEndDate = PublishRelay<Date>()
    private let addTag = PublishRelay<String?>()
    private let removeTag = PublishRelay<String?>()
    private let disposeBag = DisposeBag()

    // DI
    private let viewModel: CommunityRegisterTeambuildViewModel
    
    init() {
        self.viewModel = CommunityRegisterTeambuildViewModel()
        super.init(nibName: CommunityRegisterTeambuildViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        updateTagStackView(by: viewModel.tags)
    }
    
    private func bind() {
        output.teambuildEndDateTitle
            .drive(teambuildEndDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.competitionEndDateTitle
            .drive(competitionEndDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.competitionStartDateTitle
            .drive(competitionStartDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        photoSelectView.rx.tapGesture()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let type = UIImagePickerController.SourceType.photoLibrary
                guard UIImagePickerController.isSourceTypeAvailable(type) else {
                    print("권한이 없음")
                    return
                } // 현재 기기에서 가능한지 확인하는 부분
                
                self.present(self.imagePicker, animated: true)
            }
            .disposed(by: disposeBag)
        
        teambuildContentTextView.rx.text
            .map { !($0?.isEmpty ?? true) }
            .bind(to: teambuildContentPlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        teambuildEndDateStackView.rx.tapGesture()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.presentBottomDatePicker { date in
                    self.changeTeambuildEndDate.accept(date)
                }
            }
            .disposed(by: disposeBag)
        
        competitionStartDateStackView.rx.tapGesture()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.presentBottomDatePicker { date in
                    self.changeCompetitionStartDate.accept(date)
                }
            }
            .disposed(by: disposeBag)
        
        competitionEndDateStackView.rx.tapGesture()
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.presentBottomDatePicker { date in
                    self.changeCompetitionEndDate.accept(date)
                }
            }
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        navigationItem.title = "팀원 모집하기"
        addUnderLineOnNavBar()
        preparePhotoSelectView()
        prepareCompetitionTitleTextField()
        prepareTeambuildContentTextView()
    }
    
    private func preparePhotoSelectView() {
        photoSelectView.layer.masksToBounds = true
        photoSelectView.layer.cornerRadius = 10
    }
    
    private func prepareCompetitionTitleTextField() {
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? .systemFont(ofSize: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        competitionTitleTextField.font = font
        competitionTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "공모전의 제목을 작성해주세요",
            attributes: attributes
        )
    }
    
    private func prepareTeambuildContentTextView() {
        teambuildContentTextView.layer.masksToBounds = true
        teambuildContentTextView.layer.cornerRadius = 10
        teambuildContentTextView.layer.borderWidth = 1
        teambuildContentTextView.layer.borderColor = UIColor(rgb: 0xdddddd).cgColor
        teambuildContentTextView.textColor = .moaDarkColor
    }
}

extension CommunityRegisterTeambuildViewController: PickerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        var selectedImage: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        photoImageView.image = selectedImage
        picker.dismiss(animated: true)
    }
}

// MARK: - Update Tag
extension CommunityRegisterTeambuildViewController {
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel(title: tag)
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel(title: String) -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor(rgb: 0xf2f2f2)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = title
        label.textColor = UIColor(rgb: 0xb8b8b8)
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: CGFloat(56 + (8 * title.count))),
            contentView.heightAnchor.constraint(equalToConstant: 32),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (tapGesture: UITapGestureRecognizer) in
                guard let self = self else { return }
                if let view = tapGesture.view,
                   let label = view.subviews.first as? UILabel {
                    
                    if view.backgroundColor == .black {
                        view.backgroundColor = UIColor(rgb: 0xf2f2f2)
                        label.textColor = UIColor(rgb: 0xb8b8b8)
                        self.removeTag.accept(label.text)
                    } else {
                        view.backgroundColor = .black
                        label.textColor = .white
                        self.addTag.accept(label.text)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return contentView
    }
}
