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
        guard let nc = navigationController as? BackgroundBlur else { return self }
        return nc
    }
    
    public func presentBottomDatePicker(datePickerHandler: ((Date) -> Void)? = nil) {
        let vc = BottomDatePickerViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.datePickerHandler = datePickerHandler
        vc.blurVC = blurVC
        navigationController?.tabBarController?.present(vc, animated: true)
    }
}
