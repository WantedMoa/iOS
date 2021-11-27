//
//  BestMemberSectionModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxDataSources
import RxCocoa
import RxSwift

enum BestMemberSectionModel {
    case projectManager(items: [HomePopularUsersDetail])
    case programmer(items: [HomePopularUsersDetail])
    case productDesigner(items: [HomePopularUsersDetail])
    case marketer(items: [HomePopularUsersDetail])
}

extension BestMemberSectionModel: SectionModelType {
    typealias Item = HomePopularUsersDetail
    
    var items: [Item] {
        switch self {
        case .projectManager(let items):
            return items
        case .programmer(let items):
            return items
        case .productDesigner(let items):
            return items
        case .marketer(let items):
            return items
        }
    }
    
    init(original: BestMemberSectionModel, items: [Item]) {
        switch original {
        case .projectManager(let items):
            self = .projectManager(items: items)
        case .programmer(let items):
            self = .programmer(items: items)
        case .productDesigner(let items):
            self = .productDesigner(items: items)
        case .marketer(let items):
            self = .marketer(items: items)
        }
    }
}
