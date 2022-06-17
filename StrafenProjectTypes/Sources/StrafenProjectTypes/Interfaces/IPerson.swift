//
//  IPerson.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Person with id and a name.
public protocol IPerson {
    
    /// Type of the name of the person.
    associatedtype PersonName: IPersonName
        
    /// Id of the person.
    var id: Person.ID { get }
    
    /// Name of the person.
    var name: PersonName { get }
}

extension IPerson {
    
    /// Converts the protocol to the concrete `Person` type.
    public var concrete: Person {
        return Person(self)
    }
}
