//
//  IImportance.swift
//  
//
//  Created by Steven on 17.06.22.
//

import Foundation

/// Contains the importance of a fine or reason template.
public protocol IImportance {
    
    /// Concrete `Importance` type of this importance.
    var concreteImportance: Importance { get }
}

extension IImportance {
    
    /// Converts the protocol to the concrete `Importance` type.
    public var concrete: Importance {
        return Importance(self)
    }
}
