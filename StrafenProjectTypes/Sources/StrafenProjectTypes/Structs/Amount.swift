//
//  Amount.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains an amount value with subunit value.
public struct Amount: IAmount {
    
    /// Value of the amount.
    public private(set) var value: UInt
    
    /// Subunit value of the amount.
    @Clamping(0...99) public private(set) var subUnitValue: UInt = .zero
}

extension Amount {
    
    /// Initializes amount with a `IAmount` protocol.
    /// - Parameter amount: `IAmount` protocol to initialize the amount.
    public init(_ amount: some IAmount) {
        self.value = amount.value
        self.subUnitValue = amount.subUnitValue
    }
}

extension Amount: Equatable {
    public static func ==(lhs: Amount, rhs: Amount) -> Bool {
        return lhs.value == rhs.value && lhs.subUnitValue == rhs.subUnitValue
    }
}
