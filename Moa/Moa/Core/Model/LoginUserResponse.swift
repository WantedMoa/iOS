//
//  LoginUserResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct LoginUserResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: LoginUser?
}

struct LoginUser: Codable {
    let index: Int
    let jwt: String
    
    enum CodingKeys: String, CodingKey {
        case index = "userIdx"
        case jwt
    }
}
