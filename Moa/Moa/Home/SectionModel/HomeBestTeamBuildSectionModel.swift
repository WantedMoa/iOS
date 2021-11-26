//
//  HomeBestTeamBuildSectionModel.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

import RxDataSources
import RxCocoa
import RxSwift

enum HomeBestTeamBuildSectionModel {
    case topten(items: [String])
}

extension HomeBestTeamBuildSectionModel: SectionModelType {
    typealias Item = String
    
    var items: [Item] {
        switch self {
        case .topten(let items):
            return items
        }
    }
    
    init(original: HomeBestTeamBuildSectionModel, items: [Item]) {
        switch original {
        case .topten(let items):
            self = .topten(items: items)
        }
    }
}
