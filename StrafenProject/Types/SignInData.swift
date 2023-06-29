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
    public private(set) var signInDate: Date
    public var authentication: [UserAuthenticationType]
    public var notificationTokens: [String: String]
}

extension SignInData.UserAuthenticationType: Equatable {}

extension SignInData.UserAuthenticationType: Codable {}

extension SignInData.UserAuthenticationType: Sendable {}

extension SignInData.UserAuthenticationType: Hashable {}

extension SignInData: Equatable {
    static func ==(lhs: SignInData, rhs: SignInData) -> Bool {
        return lhs.hashedUserId == rhs.hashedUserId &&
            lhs.signInDate.timeIntervalSinceReferenceDate.rounded(.down) == rhs.signInDate.timeIntervalSinceReferenceDate.rounded(.down) && 
            lhs.authentication == rhs.authentication &&
            lhs.notificationTokens == rhs.notificationTokens
    }
}

extension SignInData: Codable {}

extension SignInData: Sendable {}

extension SignInData: Hashable {}
