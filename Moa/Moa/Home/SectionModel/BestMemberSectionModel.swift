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
    case projectManager(items: [HomeBestMember])
    case programmer(items: [HomeBestMember])
    case productDesigner(items: [HomeBestMember])
    case designer(items: [HomeBestMember])
}

extension BestMemberSectionModel: SectionModelType {
    typealias Item = HomeBestMember
    
    var items: [Item] {
        switch self {
        case .projectManager(let items):
            return items
        case .programmer(let items):
            return items
        case .productDesigner(let items):
            return items
        case .designer(let items):
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
        case .designer(let items):
            self = .designer(items: items)
        }
    }
}
