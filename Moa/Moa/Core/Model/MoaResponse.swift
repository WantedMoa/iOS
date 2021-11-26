//
//  MoaResponse.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

struct MoaResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
