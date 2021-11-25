//
//  MoaAPI.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Moya

public enum MoaAPI {
    case homeContests
    case homePopularUsers
    case homePopularUsersDetail
    case homePopularRecruits
    case communityRecruits
}

extension MoaAPI: TargetType {
    public var baseURL: URL {
        return PrivateKey.baseURL
    }
    
    public var path: String {
        switch self {
        case .homeContests:
            return "/homes/contests"
        case .homePopularUsers:
            return "/homes/popular-users"
        case .homePopularUsersDetail:
            return "/homes/popular-users/details"
        case .homePopularRecruits:
            return "/homes/popular-recruits"
        case .communityRecruits:
            return "/app/recruits"
        }
    }
    
    public var method: Method {
        switch self {
        case .homeContests,
             .homePopularUsers,
             .homePopularUsersDetail,
             .homePopularRecruits,
             .communityRecruits:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .homeContests,
            .homePopularUsers,
            .homePopularUsersDetail,
            .homePopularRecruits,
            .communityRecruits:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return ["x-access-token": PrivateKey.testToken]
    }
}
