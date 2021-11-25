//
//  MoaAPI.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Moya

public enum MoaAPI {
    case homeContest
}

extension MoaAPI: TargetType {
    public var baseURL: URL {
        return PrivateKey.baseURL
    }
    
    public var path: String {
        switch self {
        case .homeContest:
            return "/homes/contests"
        }
    }
    
    public var method: Method {
        switch self {
        case .homeContest:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .homeContest:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
