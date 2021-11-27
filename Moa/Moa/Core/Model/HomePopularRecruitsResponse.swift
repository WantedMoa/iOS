//
//  HomePopularRecruitsResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

struct HomePopularRecruitsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomePopularRecruit]?
}

struct HomePopularRecruit: Codable {
    let index: Int
    let pictureURL: String
    let title: String
    let startDate: String
    let endDate: String
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case index = "recruitIdx"
        case pictureURL = "pictureUrl"
        case title
        case startDate
        case endDate
        case tags = "tag"
    }
}
