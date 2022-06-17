//
//  Fine.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Contains all properties of a fine.
internal struct Fine {
    
    /// Id of the fine.
    public private(set) var id: UUID
    
    /// Associated person id of the fine.
    public private(set) var personId: UUID
    
    /// Payed state of the fine.
    public private(set) var payedState: Updatable<PayedState>
    
    /// Number of the fine.
    public private(set) var number: Int
    
    /// Date of the fine.
    public private(set) var date: Date
    
    /// Fine reason of the fine.
    public private(set) var fineReason: FineReason
}

extension Fine: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "id": self.id.parameter,
            "personId": self.personId,
            "payedState": self.payedState,
            "number": self.number,
            "date": self.date,
            "fineReason": self.fineReason
        ]
    }
}

extension Fine: Decodable {}
