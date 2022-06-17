//
//  IAmount.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains an amount value with subunit value.
public protocol IAmount {
    
    /// Value of the amount.
    var value: UInt { get }
    
    /// Subunit value of the amount.
    var subUnitValue: UInt { get }
}

extension IAmount {
    
    /// Converts the protocol to the concrete `Amount` type.
    public var concrete: Amount {
        return Amount(self)
    }
}
