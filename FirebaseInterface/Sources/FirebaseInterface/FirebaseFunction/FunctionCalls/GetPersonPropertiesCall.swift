//
//  GetPersonPropertiesCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Returns club and person properties of user id.
internal struct GetPersonPropertiesCall: FunctionCallable {
    
    struct ResultType: Decodable {
        
        /// Properties of person with specified user id.
        private let personProperties: PersonPropertiesWithIsAdmin
        
        /// Properties of club.
        private let clubProperties: ClubProperties
    }
    
    static let functionName: String = "getPersonProperties"
    
    /// User id of person to get properties from.
    private let userId: String
    
    var parameters: FunctionParameters {
        FunctionParameter(self.userId, for: "userId")
    }
}
