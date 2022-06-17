//
//  PersonPropertiesWithUserId.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Person properties with id, name, sign in date and user id.
internal struct PersonPropertiesWithUserId {
    
    /// Id of the person.
    public private(set) var id: UUID
    
    /// Sign in date of the person.
    public private(set) var signInDate: Date
    
    /// User id of the person.
    public private(set) var userId: String
    
    /// Name of the person.
    public private(set) var name: PersonName
}

extension PersonPropertiesWithUserId: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "id": self.id,
            "signInDate": self.signInDate,
            "userId": self.userId,
            "name": self.name
        ]
    }
}

extension PersonPropertiesWithUserId: Decodable {}
