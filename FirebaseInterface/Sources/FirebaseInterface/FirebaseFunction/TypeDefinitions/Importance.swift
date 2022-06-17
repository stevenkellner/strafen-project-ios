//
//  Importance.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Importance of a fine.
internal enum Importance: String {
    
    /// Fine has high importance.
    case high
    
    /// Fine has medium importance.
    case medium
    
    /// Fine has low imporance
    case low
}

extension Importance: FunctionParameterType {
    var parameter: String {
        return self.rawValue
    }
}

extension Importance: Decodable {}
