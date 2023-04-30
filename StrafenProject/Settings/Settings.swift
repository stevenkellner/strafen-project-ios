//
//  Settings.swift
//  StrafenProject
//
//  Created by Steven on 09.04.23.
//

import Foundation

struct Settings {
    public var appearance: Settings.Appearance
    public var signedInPerson: Settings.SignedInPerson?
}

extension Settings {
    static let `default` = Settings(appearance: .system, signedInPerson: nil)
}

extension Settings: Codable {}
