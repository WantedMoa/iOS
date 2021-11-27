//
//  CommunityDetailRecruitResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct CommunityDetailRecruitResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: CommunityDetailRecruit?
}

struct CommunityDetailRecruit: Codable {
    let index: Int
    let pictureURL: String
    let deadline: String
    let title: String
    let startDate: String
    let endDate: String
    let content: String
    let position: [String]
    let userIdx: Int
    let profileImg: String
    let bio: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case index = "recruitIdx"
        case pictureURL = "pictureUrl"
        case deadline
        case title
        case startDate
        case endDate
        case content
        case position
        case userIdx
        case profileImg
        case bio
        case name
    }
}
