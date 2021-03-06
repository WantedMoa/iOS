//
//  CommunityTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import UIKit

import Kingfisher

final class CommunityTeamBuildCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var competitionDateLabel: UILabel!
    @IBOutlet private weak var competitionTitleLabel: UILabel!
    @IBOutlet private weak var competitionContentLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        competitionImageView.layer.masksToBounds = true
        competitionImageView.layer.cornerRadius = 5
    }
    
    func update(by communityRecruit: CommunityRecruit) {
        competitionImageView.kf.setImage(with: URL(string: communityRecruit.pictureURL))
        competitionDateLabel.text = communityRecruit.startDate + "-" + communityRecruit.endDate
        competitionTitleLabel.text = communityRecruit.title
        updateTagStackView(by: communityRecruit.position)
    }

    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel(title: tag)
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel(title: String) -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7
        
        let font = UIFont.notoSansRegular(size: 9)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = title
        label.textColor = .white
        label.sizeToFit()
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: CGFloat(10 + label.bounds.width)),
            contentView.heightAnchor.constraint(equalToConstant: 15),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        return contentView
    }
}
