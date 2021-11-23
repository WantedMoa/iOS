//
//  HomeBestTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

final class HomeBestTeamBuildCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var competitionDateLabel: UILabel!
    @IBOutlet private weak var competitionTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
        updateTagStackView(by: ["iOS 경험자", "꾸준히 참여"])
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
    }
    
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel()
            label.text = "   " + tag + "   "
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel() -> UILabel {
        let font = UIFont(name: "NotoSansKR-Regular", size: 9) ?? UIFont.systemFont(ofSize: 9)
        let label = UILabel()
        label.font = font
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        return label
    }
}
