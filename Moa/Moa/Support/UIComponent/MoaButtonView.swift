//
//  MoaButtonView.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

final class MoaButtonView: UIView, IdentifierType {
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromNib()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initFromNib()
        configureUI()
    }
    
    private func initFromNib() {
        let nibName = MoaButtonView.identifier
        
        if let view = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            addSubview(view)
        }
    }
    
    private func configureUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
    }
}
