//
//  PersonName.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains first and optionally last name of a person.
public struct PersonName: IPersonName {
    
    /// First name of the person.
    public private(set) var first: String
    
    /// Last name of the person.
    public private(set) var last: String?
}

extension PersonName {
    
    /// Initializes person name with a `IPersonName` protocol.
    /// - Parameter personName: `IPersonName` protocol to initialize the person name.
    public init(_ personName: some IPersonName) {
        self.first = personName.first
        self.last = personName.last
    }
}

extension PersonName: Equatable {
    public static func ==(lhs: PersonName, rhs: PersonName) -> Bool {
        return lhs.first == rhs.first && lhs.last == rhs.last
    }
}
