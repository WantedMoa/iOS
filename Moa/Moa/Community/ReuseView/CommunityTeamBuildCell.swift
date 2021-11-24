//
//  CommunityTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import UIKit

final class CommunityTeamBuildCell: UICollectionViewCell, IdentifierType {
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
        competitionImageView.layer.masksToBounds = true
        competitionImageView.layer.cornerRadius = 5
    }
    
    func update(data: TestbestMembers) {
        competitionImageView.image = UIImage(named: data.image)
        competitionDateLabel.text = data.date
        competitionTitleLabel.text = data.title
        updateTagStackView(by: data.tags)
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
