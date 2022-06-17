//
//  VoidReturnType.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Defines a decodable void return type for firebase function calls.
internal struct VoidReturnType: Decodable {
    init(from decoder: Decoder) throws {}
}
