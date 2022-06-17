//
//  IPersonName.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains first and optionally last name of a person.
public protocol IPersonName {
    
    /// First name of the person.
    var first: String
    
    /// Last name of the person.
    var last: String?
}

extension IPersonName {
    
    /// Converts the protocol to the concrete `PersonName` type.
    public var concrete: PersonName {
        return PersonName(self)
    }
}
