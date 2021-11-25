//
//  HomeDetailBestTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class HomeDetailBestTeamBuildCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var tagStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateTagStackView(by: ["iOS 경험자", "꾸준히 참여"])
        
        competitionImageView.layer.masksToBounds = true
        competitionImageView.layer.cornerRadius = 10
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
