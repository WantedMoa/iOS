//
//  TokenManager.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

public enum TokenType: String {
    case jwt
}

public class TokenManager {
    @TokenStorage(key: TokenType.jwt.rawValue)
    public var jwt: String?
    
    public init() {}
}

@propertyWrapper
public struct TokenStorage<T> {
    public let key: String

    public init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: T? {
        get {
            return UserDefaults.standard.value(forKey: key) as? T
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
}
