//
//  Person.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Contains id and name of a person.
internal struct Person {
    
    /// Id of the person.
    public private(set) var id: UUID
    
    /// Name of a person.
    public private(set) var name: PersonName
}

extension Person: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "id": self.id,
            "name": self.name
        ]
    }
}

extension Person: Decodable {}
