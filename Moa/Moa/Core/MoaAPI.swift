//
//  MoaAPI.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Moya

public enum MoaAPI {
    // Home
    case homeContests
    case homePopularUsers
    case homePopularUsersDetail
    case homePopularRecruits
    
    // Community
    case communityRecruits
    case communityRegisterRecruit(formData: [MultipartFormData])
    case communityDetailRecruit(index: Int)
    case communityUserProfile(index: Int)
    
    // Match
    case matchRecruits
    case matchRecommends(index: Int)
    
    // Setting
    case settingUserProfile
    case settingMyTeams
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
        case .communityRecruits, .communityRegisterRecruit:
            return "/app/recruits"
        case .communityDetailRecruit(let index):
            return "/app/recruits/\(index)"
        case .matchRecruits:
            return "/recruits"
        case .matchRecommends(let index):
            return "/recruits/\(index)/recommends"
        case .settingUserProfile:
            return "/profiles"
        case .settingMyTeams:
            return "/teams"
        case .communityUserProfile(let index):
            return "/app/users/\(index)"
        }
    }
    
    public var method: Method {
        switch self {
        case .homeContests,
             .homePopularUsers,
             .homePopularUsersDetail,
             .homePopularRecruits,
             .communityRecruits,
             .communityDetailRecruit,
             .matchRecruits,
             .matchRecommends,
             .settingUserProfile,
             .settingMyTeams,
             .communityUserProfile:
            return .get
        case .communityRegisterRecruit:
            return .post
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
            .communityRecruits,
            .communityDetailRecruit,
            .matchRecruits,
            .matchRecommends,
            .settingUserProfile,
            .settingMyTeams,
            .communityUserProfile:
            return .requestPlain
        
        case .communityRegisterRecruit(let formData):
            return .uploadMultipart(formData)
        }
    }
    
    public var headers: [String : String]? {
        guard let jwt = TokenManager().jwt else { fatalError() }
//
//        switch self {
//        case .communityRegisterRecruit:
//            return [
//                "x-access-token": jwt,
//                "Content-Type": "multipart / form-data"
//            ]
//        default:
            return ["x-access-token": jwt]
//         }
    }
}
