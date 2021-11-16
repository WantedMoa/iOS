//
//  HomeBestMemberReusableView.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

final class HomeBestMemberReusableView: UICollectionReusableView, IdentifierType {
    static let headerElementKind = "section-header-element-kind"
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    func update(by title: String) {
        titleLabel.text = title
    }
}
