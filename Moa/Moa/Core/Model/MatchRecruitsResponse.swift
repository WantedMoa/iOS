//
//  MatchRecruitsResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct MatchRecruitsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [MatchRecruit]?
}

struct MatchRecruit: Codable {
    let index: Int
    let pictureURL: String
    let title, startDate, endDate: String
    let tags: [String]

    enum CodingKeys: String, CodingKey {
        case index = "recruitIdx"
        case pictureURL = "pictureUrl"
        case title, startDate, endDate
        case tags = "tag"
    }
}
