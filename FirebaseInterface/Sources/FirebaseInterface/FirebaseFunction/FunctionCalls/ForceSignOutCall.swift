//
//  ForceSignOutCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Force sign out a person.
internal struct ForceSignOutCall: FunctionCallable {
    
    static let functionName: String = "forceSignOut"
    
    /// Id of the club to force sign out the person.
    private let clubId: UUID
    
    /// Id of the person to force sign out.
    private let personId: UUID
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.personId, for: "personId")
    }
}
