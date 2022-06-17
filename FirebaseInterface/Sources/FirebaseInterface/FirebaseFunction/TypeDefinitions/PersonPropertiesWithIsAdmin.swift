//
//  PersonPropertiesWithIsAdmin.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Person properties with id, name, sign in date and if person is admin.
internal struct PersonPropertiesWithIsAdmin {
    
    /// Id of the person.
    public private(set) var id: UUID
    
    /// Sign in date of the person.
    public private(set) var signInDate: Date
    
    /// Indicates whether person is admin.
    public private(set) var isAdmin: Bool
    
    /// Name of the person
    public private(set) var name: PersonName
}

extension PersonPropertiesWithIsAdmin: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "id": self.id,
            "signInDate": self.signInDate,
            "isAdmin": self.isAdmin,
            "name": self.name
        ]
    }
}

extension PersonPropertiesWithIsAdmin: Decodable {}
