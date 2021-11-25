//
//  MoaError.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

enum MoaError: LocalizedError {
    case flatMap
    case network
    
    var errorDescription: String? {
        switch self {
        case .flatMap, .network:
            return "네트워크 에러 발생"
        }
    }
}
