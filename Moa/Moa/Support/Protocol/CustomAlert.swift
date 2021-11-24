//
//  CustomAlert.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

public protocol CustomAlert: BackgroundBlur {}

extension CustomAlert {
    var blurVC: BackgroundBlur {
        guard let vc = navigationController?.tabBarController as? BackgroundBlur else { return self }
        return vc
    }
    
    var rootVC: UIViewController? {
        return navigationController?.tabBarController
    }
    
    public func presentBottomDatePicker(datePickerHandler: ((Date) -> Void)? = nil) {
        let vc = BottomDatePickerViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.datePickerHandler = datePickerHandler
        vc.blurVC = blurVC
        rootVC?.present(vc, animated: true)
    }
    
    public func presentBottomAlert(message: String) {
        let vc = BottomAlertViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.blurVC = blurVC
        vc.message = message
        rootVC?.present(vc, animated: true)
    }
}
