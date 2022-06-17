//
//  NewClubCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Creates a new club with given properties.
/// Doesn't update club, if already a club with same club id exists.
internal struct NewClubCall: FunctionCallable {
        
    static let functionName: String = "newClub"
    
    /// Properties of the club to be created.
    private let clubProperties: ClubProperties
    
    /// Properties of the person creating the club.
    private let personProperties: PersonPropertiesWithUserId
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubProperties, for: "clubProperties")
        FunctionParameter(self.personProperties, for: "personProperties")
    }
}
