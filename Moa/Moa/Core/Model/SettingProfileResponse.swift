//
//  SettingUserProfile.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct SettingProfileResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [SettingProfile]
}

// MARK: - Result
struct SettingProfile: Codable {
    let profileImg: String
    let name, email: String
    let rating: Int
    let portfolio, experiance, bio: String
    let universityName: String
}
