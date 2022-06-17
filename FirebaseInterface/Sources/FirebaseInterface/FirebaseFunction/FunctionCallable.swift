//
//  FunctionCallable.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Protocol that can be used to call a firebase function.
protocol FunctionCallable {
    
    /// Type of the call return data.
    associatedtype ReturnType: Decodable
    
    /// Name of the firebase function to call.
    static var functionName: String { get }
    
    /// Contains parameters for the firebase function call.
    @FunctionParametersBuilder var parameters: FunctionParameters { get }
}

extension FunctionCallable {
    typealias ReturnType = VoidReturnType
}
