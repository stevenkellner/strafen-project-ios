//
//  RegisterPersonCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Register person to club with given club id.
internal struct RegisterPersonCall: FunctionCallable {
    
    typealias ResultType = ClubProperties
    
    static let functionName: String = "registerPerson"
    
    /// Id of the club to change the person.
    private let clubId: UUID
    
    /// Properties of person to register.
    private let personProperties: PersonPropertiesWithUserId
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.personProperties, for: "personProperties")
    }
}
