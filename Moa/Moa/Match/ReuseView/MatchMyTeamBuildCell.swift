//
//  MatchMyTeamBuildCell.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import UIKit

final class MatchMyTeamBuildCell: UICollectionViewCell, IdentifierType {

    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
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
}
