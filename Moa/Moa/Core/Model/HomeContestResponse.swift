//
//  HomeContestResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

struct HomeContestResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeContest]?
}

struct HomeContest: Codable {
    let index: Int
    let pictureURL: String
    let linkURL: String
    
    enum CodingKeys: String, CodingKey {
        case index = "contestIdx"
        case pictureURL = "pictureUrl"
        case linkURL = "linkUrl"
    }
}
