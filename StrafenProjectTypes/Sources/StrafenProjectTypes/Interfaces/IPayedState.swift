//
//  IPayedState.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains properties if a fine is payed.
public protocol IPayedState {
    
    /// Concrete `PayedState` type of this payed state.
    var concretePayedState: PayedState { get }
}

extension IPayedState {
    
    /// Converts the protocol to the concrete `PayedState` type.
    public var concrete: PayedState {
        return PayedState(self)
    }
}
