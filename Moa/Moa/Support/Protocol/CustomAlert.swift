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
        if let tabVC = navigationController?.tabBarController as? BackgroundBlur {
            return tabVC
        }
        
        if let navVC = navigationController as? BackgroundBlur {
            return navVC
        }
        
        return self
    }
    
    var rootVC: UIViewController? {
        if let tabVC = navigationController?.tabBarController as? BackgroundBlur {
            return tabVC
        }
        
        if let navVC = navigationController as? BackgroundBlur {
            return navVC
        }
        
        return self
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
    
    public func presentBottomPosition(positionHandler: ((String, Int) -> Void)?) {
        let vc = BottomPositionViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .coverVertical
        vc.blurVC = blurVC
        rootVC?.present(vc, animated: true)
    }
}
