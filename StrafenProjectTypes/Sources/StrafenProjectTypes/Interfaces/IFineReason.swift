//
//  IFineReason.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains a reason of a fine, either with a template id or custom with reason message, amount and importance.
public protocol IFineReason {
    
    /// Concrete `FineReason` type of this fine reason.
    var concreteFineReason: FineReason { get }
}

extension IFineReason {
    
    /// Converts the protocol to the concrete `FineReason` type.
    public var concrete: FineReason {
        return FineReason(self)
    }
}
