//
//  ReasonTemplate.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Reason template with id, reason message, amount and importance.
internal struct ReasonTemplate {
    
    /// Id of the reason.
    public private(set) var id: UUID
    
    /// Message of the reason.
    public private(set) var reasonMessage: String
    
    /// Amount if the reason.
    public private(set) var amount: Amount
    
    /// Importance of the reason.
    public private(set) var importance: Importance
}

extension ReasonTemplate: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "id": self.id,
            "reasonMessage": self.reasonMessage,
            "amount": self.amount,
            "importance": self.importance
        ]
    }
}

extension ReasonTemplate: Decodable {}
