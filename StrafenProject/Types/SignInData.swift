//
//  SignInData.swift
//  StrafenProject
//
//  Created by Steven on 29.04.23.
//

import Foundation

struct SignInData {
    enum UserAuthenticationType: String {
        case clubMember
        case clubManager
    }
    
    public private(set) var hashedUserId: String
    public private(set) var signInDate: UtcDate
    public var authentication: [UserAuthenticationType]
    public var notificationTokens: [String: String]
}

extension SignInData.UserAuthenticationType: Equatable {}

extension SignInData.UserAuthenticationType: Codable {}

extension SignInData.UserAuthenticationType: Sendable {}

extension SignInData.UserAuthenticationType: Hashable {}

extension SignInData: Equatable {}

extension SignInData: Codable {}

extension SignInData: Sendable {}

extension SignInData: Hashable {}
