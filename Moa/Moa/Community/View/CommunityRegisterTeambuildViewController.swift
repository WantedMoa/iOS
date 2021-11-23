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

final class CommunityRegisterTeambuildViewController: UIViewController, UnderLineNavBar {
    @IBOutlet private weak var photoSelectView: UIView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var competitionTitleTextField: UITextField!
    @IBOutlet private weak var teambuildContentTextView: UITextView!
    @IBOutlet private weak var teambuildContentPlaceholderLabel: UILabel!

    private lazy var imagePicker: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        return vc
    }()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
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
