//
//  ChangeReasonTemplateCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Changes a element of reason template list.
internal struct ChangeReasonTemplateCall: FunctionCallable {
    
    static let functionName: String = "changeReasonTemplate"
    
    /// Id of the club to change the reason.
    private let clubId: UUID
    
    /// Type of the change.
    private let changeType: ChangeType
    
    /// Reason to change.
    private let updatableReasonTemplate: Updatable<Deletable<ReasonTemplate, UUID>>
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.changeType, for: "changeType")
        FunctionParameter(self.updatableReasonTemplate, for: "updatableReasonTemplate")
    }
}
