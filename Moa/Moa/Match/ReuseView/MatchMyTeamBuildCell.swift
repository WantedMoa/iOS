//
//  MatchMyTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import UIKit

import Kingfisher

final class MatchMyTeamBuildCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var competitionDateLabel: UILabel!
    @IBOutlet private weak var competitionTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func update(by communityRecruit: CommunityRecruit) {
        competitionImageView.kf.setImage(with: URL(string: communityRecruit.pictureURL))
        competitionDateLabel.text = communityRecruit.startDate
        competitionTitleLabel.text = communityRecruit.title
    }
    
    func update(by matchRecruit: MatchRecruit) {
        competitionImageView.kf.setImage(with: URL(string: matchRecruit.pictureURL))
        competitionDateLabel.text = matchRecruit.startDate
        competitionTitleLabel.text = matchRecruit.title
        updateTagStackView(by: matchRecruit.tags)
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
        competitionImageView.layer.masksToBounds = true
        competitionImageView.layer.cornerRadius = 5
    }
    
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel()
            label.text = "#" + tag
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel() -> UILabel {
        let font = UIFont.notoSansRegular(size: 11)
        let label = UILabel()
        label.font = font
        label.textColor = UIColor(rgb: 0xb8b8b8)
        return label
    }
}
