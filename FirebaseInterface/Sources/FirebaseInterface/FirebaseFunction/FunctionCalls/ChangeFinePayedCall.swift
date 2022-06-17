//
//  ChangeFinePayedCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Changes payement state of fine with specified fine id.
internal struct ChangeFinePayedCall: FunctionCallable {
    
    static let functionName: String = "changeFinePayed"
    
    /// Id of the club to change the payed state.
    private let clubId: UUID
    
    /// Id of fine of the payed state.
    private let fineId: UUID
    
    /// Payed state to change.
    private let updatablePayedState: Updatable<PayedState>
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.fineId, for: "fineId")
        FunctionParameter(self.updatablePayedState, for: "updatablePayedState")
    }
}
