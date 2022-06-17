//
//  LatePaymentInterest.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Late payement interest
internal struct LatePaymentInterest {
    
    /// Contains a value and an unit (`day`, `month`, `year`).
    internal struct TimePeriod {
        
        /// Unit of a time period.
        internal enum Unit: String {
            
            /// Day unit of a time period.
            case day
            
            /// Month unit of a time period.
            case month
            
            /// Year unit of a time period.
            case year
        }
        
        /// Value of the time period.
        public private(set) var value: Int
        
        /// Unit of the time period.
        public private(set) var unit: Unit
    }
    
    /// Interestfree period of the late payment interest.
    public private(set) var interestFreePeriod: TimePeriod
    
    /// Interest period of the late payment interest.
    public private(set) var interestPeriod: TimePeriod
    
    /// Interest rate of the late payment interest.
    public private(set) var interestRate: Double
    
    /// Compound interest of the late payment interest.
    public private(set) var compoundInterest: Bool
}

extension LatePaymentInterest.TimePeriod.Unit: FunctionParameterType {
    var parameter: String {
        return self.rawValue
    }
}

extension LatePaymentInterest.TimePeriod.Unit: Decodable {}

extension LatePaymentInterest.TimePeriod: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "value": self.value,
            "unit": self.unit
        ]
    }
}

extension LatePaymentInterest.TimePeriod: Decodable {}

extension LatePaymentInterest: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        return [
            "interestFreePeriod": self.interestFreePeriod,
            "interestPeriod": self.interestPeriod,
            "interestRate": self.interestRate,
            "compoundInterest": self.compoundInterest
        ]
    }
}

extension LatePaymentInterest: Decodable {}
