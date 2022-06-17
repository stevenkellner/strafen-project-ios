//
//  Person.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Person with id and a name.
public struct Person: IPerson {
    
    /// Type of the id of the person.
    public typealias ID = Tagged<(Person, id: ()), UUID>
    
    /// Id of the person.
    public private(set) var id: ID
    
    /// Name of the person.
    public private(set) var name: PersonName
}

extension Person {
    
    /// Initializes person with a `IPerson` protocol.
    /// - Parameter person: `IPerson` protocol to initialize the person.
    public init(_ person: some IPerson) {
        self.id = person.id
        self.name = PersonName(person.name)
    }
}

extension Person: Equatable {
    public static func ==(lhs: ReasonTemplate, rhs: ReasonTemplate) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
