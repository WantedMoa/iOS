//
//  HomePopularUsersDetailResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

struct HomePopularUsersDetailResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomePopularUsersDetailResult?
}

struct HomePopularUsersDetailResult: Codable {
    let projectManagers: [HomePopularUsersDetail]
    let developers: [HomePopularUsersDetail]
    let designers: [HomePopularUsersDetail]
    let marketers: [HomePopularUsersDetail]
    
    enum CodingKeys: String, CodingKey {
        case projectManagers = "pmList"
        case developers = "developerList"
        case designers = "designerList"
        case marketers = "marketerListResult"
    }
}

struct HomePopularUsersDetail: Codable {
    let index: Int
    let profileImageURL: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case index = "userIdx"
        case profileImageURL = "profileImg"
        case name
    }
}
