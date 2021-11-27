//
//  MatchRecommendsResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct MatchRecommendsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [MatchRecommend]?
}

struct MatchRecommend: Codable {
    let index: Int
    let profileImgURL: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case index = "userIdx"
        case profileImgURL = "profileImg"
        case name
    }
}
