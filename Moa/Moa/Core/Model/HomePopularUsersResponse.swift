//
//  HomePopularUsersResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

struct HomePopularUsersResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomePopularUser]?
}

struct HomePopularUser: Codable {
    let index: Int
    let profileImageURL: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case index = "userIdx"
        case profileImageURL = "profileImg"
        case name
    }
}
