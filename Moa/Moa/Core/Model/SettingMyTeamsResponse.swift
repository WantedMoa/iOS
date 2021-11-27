//
//  SettingMyTeams.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct SettingMyTeamsResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [SettingMyTeam]
}

struct SettingMyTeam: Codable {
    let recruitIdx: Int
    let title, content: String
    let member: [SettingMyTeamMember]
}

struct SettingMyTeamMember: Codable {
    let userIdx: Int
    let profileImg: String
    let name: String
    let rating: Int
}
