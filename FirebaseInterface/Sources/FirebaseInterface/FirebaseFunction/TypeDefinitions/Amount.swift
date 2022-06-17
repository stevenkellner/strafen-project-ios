//
//  Amount.swift
//  
//
//  Created by Steven on 12.06.22.
//

import CodableFirebase

/// Stores an amount value
internal struct Amount {
    
    /// Value of the amount
    public private(set) var value: UInt
    
    /// Value of the sub unit of the amount
    @Clamping(0...99) public private(set) var subUnitValue: UInt = .zero
}

extension Amount: FunctionParameterType {
    var parameter: Double {
        return Double(self.value) + Double(self.subUnitValue) / 100
    }
}

extension Amount: Decodable {
    private init(fromDouble value: Double) {
        self.value = UInt(value)
        self.subUnitValue = UInt(value * 100) - self.value * 100
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawAmount = try container.decode(Double.self)
        
        guard rawAmount >= 0 else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Amount is negative.")
        }
        
        self.init(fromDouble: rawAmount)
    }
}
