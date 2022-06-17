//
//  PersonName.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Name of a person.
internal struct PersonName {
    
    /// First name of a person.
    public private(set) var first: String
    
    /// Last name of a person.
    public private(set) var last: String?
}

extension PersonName: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "first": self.first,
            "last": self.last
        ]
    }
}

extension PersonName: Decodable {}
