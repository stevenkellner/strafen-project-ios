//
//  IFine.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains all properties of a fine.
public protocol IFine {
    
    /// Type of the payed state of the fine.
    associatedtype PayedState: IPayedState
    
    /// Type of the fine reason of the fine.
    associatedtype FineReason: IFineReason
    
    /// Id of the fine.
    var id: Fine.Id { get }
    
    /// Associated person id of the fine.
    var personId: Person.ID { get }
    
    /// Payed state of the fine.
    var payedState: PayedState { get }
    
    /// Number of the fine.
    var number: UInt { get }
    
    /// Date of the fine.
    var date: Date { get }
    
    /// Fine reason of the fine.
    var fineReason: FineReason { get }
}

extension IFine {
    
    /// Converts the protocol to the concrete `Fine` type.
    public var concrete: Fine {
        return Fine(self)
    }
}
