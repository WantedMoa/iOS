//
//  CommunityUserProfileResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct CommunityUserProfileResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: CommunityUserProfile
}

struct CommunityUserProfile: Codable {
    let userIdx: Int
    let name, university, bio, experiance: String
    let portfolio: String
}
