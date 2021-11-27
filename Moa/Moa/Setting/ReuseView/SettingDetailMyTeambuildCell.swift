//
//  SettingDetailMyTeambuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

final class SettingDetailMyTeambuildCell: UICollectionViewCell, IdentifierType {
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var subTitleLabel: UILabel!
    @IBOutlet private(set) weak var teamMemberStackView: UIStackView!
    @IBOutlet private(set) weak var moaButtonView: MoaButtonView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        updateTagStackView(by: ["TestProfile1", "TestProfile2", "TestProfile3", "TestProfile4"])
    }

    private func configureUI() {
        backgroundColor = .white
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4.0
        
        moaButtonView.contentView.backgroundColor = .init(rgb: 0xdddddd)
        moaButtonView.titleLabel.textColor = .black
        moaButtonView.titleLabel.text = "팀원 평가하기"
    }
    
    private func updateTagStackView(by tags: [String]) {
        for subView in teamMemberStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel(title: tag)
            teamMemberStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel(title: String) -> UIView {
        let contentView = UIImageView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.image = UIImage(named: title)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 37),
            contentView.heightAnchor.constraint(equalToConstant: 37)
        ])
        
        return contentView
    }
}
