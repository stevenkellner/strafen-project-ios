//
//  Settings+SignedInPerson.swift
//  StrafenProject
//
//  Created by Steven on 09.04.23.
//

import Foundation

extension Settings {
    struct SignedInPerson {
        public private(set) var id: Person.ID
        public private(set) var name: PersonName
#if !NOTIFICATION_SERVICE_EXTENSION
        public var fineIds: [Fine.ID]
#else
        public private(set) var fineIds: [UUID]
#endif
        public private(set) var isAdmin: Bool
        public private(set) var hashedUserId: String
        public var club: ClubProperties
    }
}

extension Settings.SignedInPerson: Sendable {}

extension Settings.SignedInPerson: Equatable {
    static func ==(lhs: Settings.SignedInPerson, rhs: Settings.SignedInPerson) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.fineIds == rhs.fineIds &&
            lhs.isAdmin == rhs.isAdmin &&
            lhs.hashedUserId == rhs.hashedUserId &&
            lhs.club == rhs.club
    }
}

extension Settings.SignedInPerson: Hashable {}

extension Settings.SignedInPerson: Codable {}

#if !NOTIFICATION_SERVICE_EXTENSION && !WIDGET_EXTENSION
extension Settings.SignedInPerson: PersonWithFines {}
#endif
