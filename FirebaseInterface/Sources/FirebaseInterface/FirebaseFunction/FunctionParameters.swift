//
//  FunctionParameters.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Contains parameters for a firebase function call.
internal struct FunctionParameters {
    
    /// Dictionary with key and associated parameter.
    public private(set) var parameters: [String: InternalFunctionParameterType]
    
    /// Initializes empty function parameters.
    public init() {
        self.parameters = [:]
    }
    
    /// Initializes function parameters with specified parameters.
    /// - Parameter parameters: Parameters for a firebase function call.
    public init(_ parameters: [String: any FunctionParameterType]) {
        self.parameters = parameters.mapValues(\.internalParameter)
    }
    
    /// Appends parameter with specified key or updates parameter if key already exists.
    /// - Parameters:
    ///   - parameter: Parameter to append to the function parameters.
    ///   - key: Key of the parameter to append.
    public mutating func append(_ parameter: some FunctionParameterType, for key: String) {
        self.parameters[key] = parameter.internalParameter
    }
    
    /// Appends all parameters or updates if key already exists.
    /// - Parameter parameters: Parameters to append to the function parameters.
    public mutating func append(contentsOf parameters: some Sequence<(key: String, value: any FunctionParameterType)>) {
        for (key, parameter) in parameters {
            self.append(parameter, for: key)
        }
    }
    
    /// Removes parameter with specified key.
    /// - Parameter key: Key of the parameter to remove.
    public mutating func remove(with key: String) {
        self.parameters.removeValue(forKey: key)
    }
    
    /// Gets parameter with specified key or nil if no parameter with specified key exists.
    /// - Parameter key: Key of parameter to get
    /// - Returns: Parameter with specified key or nil if no parameter with specified key exists.
    public mutating func get(with key: String) -> (InternalFunctionParameterType)? {
        return self.parameters[key]
    }
    
    /// Gets or sets parameter with specified key or nil for removing parameter.
    /// - Parameter key: Key of parameter to get or set.
    /// - Returns: Parameter with specified key or nil if no parameter with specified key exists.
    public subscript(_ key: String) -> (InternalFunctionParameterType)? {
        get {
            return self.parameters[key]
        }
        set {
            self.parameters[key] = newValue
        }
    }
}

/// Contains a firebaes function parameter and the associated key.
internal struct FunctionParameter<Parameter> where Parameter: FunctionParameterType {
    
    /// Key of the function parameter.
    public let key: String
    
    /// Firebase function parameter
    public let parameter: Parameter
    
    /// Constructs function parameter with associated key
    /// - Parameters:
    ///   - parameter: Firebase function parameter
    ///   - key: Key of the function parameter.
    init(_ parameter: Parameter, for key: String) {
        self.parameter = parameter
        self.key = key
    }
}

/// Builds firebase function parameters
@resultBuilder
internal struct FunctionParametersBuilder {
    typealias Expression = FunctionParameter
    typealias Component = [String: any FunctionParameterType]
    typealias FinalResult = FunctionParameters
    
    static func buildFinalResult(_ component: Component) -> FinalResult {
        return FunctionParameters(component)
    }
    
    static func buildExpression(_ expression: Expression<some FunctionParameterType>) -> Component {
        return [expression.key: expression.parameter]
    }
    
    static func buildBlock(_ components: Component...) -> Component {
        return components.reduce(into: [:]) { partialResult, component in
            partialResult.merge(component) { _, value in value }
        }
    }
    
    static func buildArray(_ components: [Component]) -> Component {
        return components.reduce(into: [:]) { partialResult, component in
            partialResult.merge(component) { _, value in value }
        }
    }
    
    static func buildOptional(_ component: Component?) -> Component {
        return component ?? [:]
    }
    
    static func buildEither(first component: Component) -> Component {
        return component
    }
    
    static func buildEither(second component: Component) -> Component {
        return component
    }
}

/// Contains a valid value as parameter for a firebase function call.
internal indirect enum InternalFunctionParameterType {
    
    /// Contains a `Bool` value.
    case bool(Bool)
    
    /// Contains a `Int` value.
    case int(Int)
    
    /// Contains a `UInt` value.
    case uint(UInt)
    
    /// Contains a `Double` value.
    case double(Double)
    
    /// Contains a `Float` value.
    case float(Float)
    
    /// Contains a `String` value.
    case string(String)
    
    /// Contains a `Optional` value.
    case optional(Optional<InternalFunctionParameterType>)
    
    /// Contains a `Array` value.
    case array(Array<InternalFunctionParameterType>)
    
    /// Contains a `Dictionary` value.
    case dictionary(Dictionary<String, InternalFunctionParameterType>)
    
    /// Converts parameter to a firebase function parameter.
    public var firebaseFunctionParameter: Any {
        switch self {
        case .bool(let value):
            return value
        case .int(let value):
            return value
        case .uint(let value):
            return value
        case .double(let value):
            return value
        case .float(let value):
            return value
        case .string(let value):
            return value
        case .optional(let value):
            return value.map(\.firebaseFunctionParameter) as Any
        case .array(let value):
            return value.map(\.firebaseFunctionParameter)
        case .dictionary(let value):
            return value.mapValues(\.firebaseFunctionParameter)
        }
    }
}

/// Type that can be used as firebase function parameter.
internal protocol FunctionParameterType<Parameter> {
    
    /// Parameter for a function call.
    associatedtype Parameter: FunctionParameterType
    
    /// Parameter for a function call.
    var parameter: Parameter { get }
    
    /// Valid value as parameter for a firebase function call.
    var internalParameter: InternalFunctionParameterType { get }
}

extension FunctionParameterType {
    var internalParameter: InternalFunctionParameterType {
        return self.parameter.internalParameter
    }
}

extension Bool: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .bool(self) }
    var parameter: Self { self }
}

extension Int: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .int(self) }
    var parameter: Self { self }
}

extension UInt: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .uint(self) }
    var parameter: Self { self }
}

extension Double: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .double(self) }
    var parameter: Self { self }
}

extension Float: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .float(self) }
    var parameter: Self { self }
}

extension String: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .string(self) }
    var parameter: Self { self }
}

extension Optional: FunctionParameterType where Wrapped: FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .optional(self.map(\.internalParameter)) }
    var parameter: Self { self }
}

extension Array: FunctionParameterType where Element == any FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .array(self.map(\.internalParameter)) }
    var parameter: Self { self }
}

extension Dictionary: FunctionParameterType where Key == String, Value == any FunctionParameterType {
    var internalParameter: InternalFunctionParameterType { .dictionary(self.mapValues(\.internalParameter)) }
    var parameter: Self { self }
}

extension UUID: FunctionParameterType {
    var parameter: String {
        return self.uuidString
    }
}

extension Date: FunctionParameterType {
    var parameter: String {
        self.ISO8601Format(.iso8601)
    }
}
