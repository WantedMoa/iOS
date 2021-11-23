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
    }

    private func configureUI() {
        navigationItem.title = "팀원 모집하기"
        addUnderLineOnNavBar()
        preparePhotoSelectView()
    }
    
    private func preparePhotoSelectView() {
        photoSelectView?.layer.masksToBounds = true
        photoSelectView?.layer.cornerRadius = 10
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
            self.photoImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.photoImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
