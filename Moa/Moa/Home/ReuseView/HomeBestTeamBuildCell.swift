//
//  HomeBestTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import Kingfisher

final class HomeBestTeamBuildCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var competitionDateLabel: UILabel!
    @IBOutlet private weak var competitionTitleLabel: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        backgroundColor = .white
        contentView.layer.masksToBounds = false
        competitionImageView.layer.masksToBounds = true
        competitionImageView.layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.cornerRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 4.0
    }
    
    func update(by homePopularRecruit: HomePopularRecruit) {
        competitionImageView.kf.setImage(with: URL(string: homePopularRecruit.pictureURL))
        competitionDateLabel.text = homePopularRecruit.startDate + "-" + homePopularRecruit.endDate
        competitionTitleLabel.text = homePopularRecruit.title
        updateTagStackView(by: homePopularRecruit.tags)
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
