//
//  ChangeFineCall.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Changes a element of fine list.
internal struct ChangeFineCall: FunctionCallable {
    
    static let functionName: String = "changeFine"
    
    /// Id of the club to change the fine.
    private let clubId: UUID
    
    /// Types of a list item change.
    private let changeType: ChangeType
    
    /// Fine to change.
    private let updatableFine: Updatable<Deletable<Fine, UUID>>
    
    var parameters: FunctionParameters {
        FunctionParameter(self.clubId, for: "clubId")
        FunctionParameter(self.changeType, for: "changeType")
        FunctionParameter(self.updatableFine, for: "updatableFine")
    }
}
