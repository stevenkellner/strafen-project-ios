//
//  FineReason.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains a reason of a fine, either with a template id or custom with reason message, amount and importance.
public enum FineReason: IFineReason {
    
    /// Fine reason with template id.
    case template(reasonTemplateId: ReasonTemplate.ID)
    
    /// Custom fine reason with reason message, amount and importance.
    case custom(reasonMessage: String, amount: Amount, importance: Importance)
    
    public var concreteFineReason: FineReason { self }
}

extension FineReason {
    
    /// Initializes fine reason with a `IFineReason` protocol.
    /// - Parameter fineReason: `IFineReason` protocol to initialize the fine reason.
    public init(_ fineReason: some IFineReason) {
        self = fineReason.concreteFineReason
    }
}

extension FineReason: Equatable {
    public static func ==(lhs: FineReason, rhs: FineReason) -> Bool {
        switch (lhs, rhs) {
        case (
                .template(reasonTemplateId: let lhsReasonTemplateId),
                .template(reasonTemplateId: let rhsReasonTemplateId)
            ):
            return lhsReasonTemplateId == rhsReasonTemplateId
        case (
                .custom(reasonMessage: let lhsReasonMessage, amount: let lhsAmount, importance: let lhsImportance),
                .custom(reasonMessage: let rhsReasonMessage, amount: let rhsAmount, importance: let rhsImportance)
            ):
            return lhsReasonMessage == rhsReasonMessage && lhsAmount == rhsAmount && lhsImportance == rhsImportance
        default:
            return false
        }
    }
}
