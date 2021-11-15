//
//  HomeBestMemberCell.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

typealias HomeBestMember = (profileImage: String, name: String)

final class HomeBestMemberCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func update(by homeBestMember: HomeBestMember) {
        profileImageView.image = UIImage(named: homeBestMember.profileImage)
        nameLabel.text = homeBestMember.name
    }
    
    private func configureUI() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 76 / 2
    }
}
