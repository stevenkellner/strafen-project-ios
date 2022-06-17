//
//  DatabaseType.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Type of the database for firebase function calls.
internal enum DatabaseType: String {
    
    /// Changes content on the release database.
    case release
    
    /// Changes content on the debug database.
    case debug
    
    /// Changes content on the testing database.
    case testing
    
    /// `release` or `debug` depending on the build settings.
    public static var `default`: DatabaseType {
#if DEBUG
        return .debug
#else
        return .release
#endif
    }
}

extension DatabaseType: FunctionParameterType {
    var parameter: String {
        return self.rawValue
    }
}

extension DatabaseType: Decodable {}
