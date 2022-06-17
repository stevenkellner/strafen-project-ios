//
//  ReasonTemplate.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Reason template with id, reason message, amount and importance.
public struct ReasonTemplate: IReasonTemplate {
    
    /// Type of the id of the reason template.
    public typealias ID = Tagged<(ReasonTemplate, id: ()), UUID>
    
    /// Id of the reason template.
    public private(set) var id: ID
    
    /// Reason message of the reason template.
    public private(set) var reasonMessage: String
    
    /// Amount of the reason template.
    public private(set) var amount: Amount
    
    /// Importance of the reason template.
    public private(set) var importance: Importance
}

extension ReasonTemplate {
    
    /// Initializes reason template with a `IReasonTemplate` protocol.
    /// - Parameter reasonTemplate: `IReasonTemplate` protocol to initialize the reason template.
    public init(_ reasonTemplate: some IReasonTemplate) {
        self.id = reasonTemplate.id
        self.reasonMessage = reasonTemplate.reasonMessage
        self.amount = Amount(reasonTemplate.amount)
        self.importance = Importance(reasonTemplate.importance)
    }
}

extension ReasonTemplate: Equatable {
    public static func ==(lhs: ReasonTemplate, rhs: ReasonTemplate) -> Bool {
        return lhs.id == rhs.id && lhs.reasonMessage == rhs.reasonMessage && lhs.amount == rhs.amount && lhs.importance == rhs.importance
    }
}
