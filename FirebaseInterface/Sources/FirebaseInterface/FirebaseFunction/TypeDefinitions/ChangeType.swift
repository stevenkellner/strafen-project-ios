//
//  DatabaseType.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Types of a list item change.
internal enum ChangeType: String {
    
    /// Update or add a list item.
    case update
    
    /// Delete a list item.
    case delete
}

extension ChangeType: FunctionParameterType {
    var parameter: String {
        return self.rawValue
    }
}

extension ChangeType: Decodable {}
