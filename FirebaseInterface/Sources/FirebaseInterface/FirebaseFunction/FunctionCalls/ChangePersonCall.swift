//
//  ChangePersonCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Changes a element of person list.
internal struct ChangePersonCall: FunctionCallable {
    
    static let functionName: String = "changePerson"
    
    /// Id of the club to change the person.
    private let clubId: UUID
    
    /// Type of the change.
    private let changeType: ChangeType
    
    /// Person to change.
    private let updatablePerson: Updatable<Deletable<Person, UUID>>
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.changeType, for: "changeType")
        FunctionParameter(self.updatablePerson, for: "updatablePerson")
    }
}
