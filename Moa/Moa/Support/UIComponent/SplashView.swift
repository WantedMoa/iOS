//
//  SplashView.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import UIKit

final class SplashView: UIView, IdentifierType {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
    }
    
    private func initFromNib() {
        let nibName = SplashView.identifier
        
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
}
