//
//  ChangeLatePaymentInterestCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Changes the late payment interest of club with given club id.
internal struct ChangeLatePaymentInterestCall: FunctionCallable {
    
    static let functionName: String = "changeLatePaymentInterest"
    
    /// Id of the club to change the late payment interest.
    private let clubId: UUID
    
    /// Type of the change.
    private let changeType: ChangeType
    
    /// Late payment interest to change.
    private let updatableInterest: Updatable<Deletable<LatePaymentInterest, UUID?>>
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.changeType, for: "changeType")
        FunctionParameter(self.updatableInterest, for: "updatableInterest")
    }
}
