//
//  PayedState.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains properties if a fine is payed.
public enum PayedState: IPayedState {
    
    /// Fine is payed.
    case payed(inApp: Bool, payDate: Date)
    
    /// Fine is unpayed.
    case unpayed
    
    /// Fine is settled.
    case settled
    
    public var concretePayedState: PayedState { self }
}

extension PayedState {
    
    /// Initializes payed state with a `IPayedState` protocol.
    /// - Parameter payedState: `IPayedState` protocol to initialize the payed state.
    public init(_ payedState: some IPayedState) {
        self = payedState.concretePayedState
    }
}

extension PayedState: Equatable {
    public static func ==(lhs: PayedState, rhs: PayedState) -> Bool {
        switch (lhs, rhs) {
        case (
                .payed(inApp: let lhsInApp, payDate: let lhsPayDate),
                .payed(inApp: let rhsInApp, payDate: let rhsPayDate)
            ):
            return lhsInApp == rhsInApp && Calendar.current.isDate(lhsPayDate, equalTo: rhsPayDate, toGranularity: .nanosecond)
        case (.unpayed, .unpayed):
            return true
        case (.settled, .settled):
            return true
        default:
            return false
        }
    }
}
