//
//  HomeBestMemberCell.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import Kingfisher

final class HomeBestMemberCell: UICollectionViewCell, IdentifierType {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var profileStatusImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func update(by homePopularUser: HomePopularUser, isHiddenStatus: Bool = true) {
        profileImageView.kf.setImage(with: URL(string: homePopularUser.profileImageURL))
        nameLabel.text = homePopularUser.name
        profileStatusImageView.isHidden = isHiddenStatus
    }
    
    func update(by homeBestMember: HomeBestMember, isHiddenStatus: Bool = true) {
        profileImageView.image = UIImage(named: homeBestMember.profileImage)
        nameLabel.text = homeBestMember.name
        profileStatusImageView.isHidden = isHiddenStatus
    }
    
    private func configureUI() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 76 / 2
    }
}
