//
//  IReasonTemplate.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Reason template with id, reason message, amount and importance.
public protocol IReasonTemplate {
    
    /// Type of the amount of the reason template.
    associatedtype Amount: IAmount
    
    /// Type of the importance of the reason template.
    associatedtype Importance: IImportance
    
    /// Id of the reason template.
    var id: ReasonTemplate.ID { get }
    
    /// Reason message of the reason template.
    var reasonMessage: String { get }
    
    /// Amount of the reason template.
    var amount: Amount { get }
    
    /// Importance of the reason template.
    var importance: Importance { get }
}

extension IReasonTemplate {
    
    /// Converts the protocol to the concrete `ReasonTemplate` type.
    public var concrete: ReasonTemplate {
        return ReasonTemplate(self)
    }
}
