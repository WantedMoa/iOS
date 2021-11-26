//
//  LoginAPI.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Moya

public enum LoginAPI {
    case requestEmailAuth(param: [String: Any])
    case checkEmailAuth(email: String)
    case registerUser(param: [String: Any])
}

extension LoginAPI: TargetType {
    public var baseURL: URL {
        switch self {
        case .checkEmailAuth(let email):
            return URL(
                string: PrivateKey.baseURLString + "?email=\(email)"
            )!
        default:
            return PrivateKey.baseURL
        }
        
    }
    
    public var path: String {
        switch self {
        case .requestEmailAuth:
            return "/app/email-send"
        case .checkEmailAuth:
            return "/app/users/check"
        case .registerUser:
            return "/app/users"
        }
    }
    
    public var method: Method {
        switch self {
        case .requestEmailAuth, .checkEmailAuth, .registerUser:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        // GET
        case .checkEmailAuth:
            return .requestPlain
            
        // POST
        case .requestEmailAuth(let param),
             .registerUser(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
