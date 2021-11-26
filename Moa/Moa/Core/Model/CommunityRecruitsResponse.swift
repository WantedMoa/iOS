//
//  CommunityRecruitsResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct CommunityRecruitsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [CommunityRecruit]?
}

struct CommunityRecruit: Codable {
    let index: Int
    let pictureURL: String
    let title: String
    let startDate: String
    let endDate: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case index = "recruitIdx"
        case pictureURL = "pictureUrl"
        case title
        case startDate
        case endDate
        case content
    }
}
