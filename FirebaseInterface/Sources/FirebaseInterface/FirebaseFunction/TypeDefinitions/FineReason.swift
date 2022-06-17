//
//
// FineReason.swift
//  
//
//  Created by Steven on 12.06.22.
//

import Foundation

/// Contains a reason of a fine, either with a template id or custom with reason message, amount and importance.
internal enum FineReason {
    
    /// Fine reason with template id.
    case template(reasonTemplateId: UUID)
    
    /// Custom fine reason with reason message, amount and importance.
    case custom(reasonMessage: String, amount: Amount, importance: Importance)
}

extension FineReason: FunctionParameterType {
    var parameter: [String: any FunctionParameterType] {
        switch self {
        case .template(let reasonTemplateId):
            return [
                "reasonTemplateId": reasonTemplateId
            ]
        case .custom(let reasonMessage, let amount, let importance):
            return [
                "reasonMessage": reasonMessage,
                "amount": amount,
                "importance": importance
            ]
        }
    }
}

extension FineReason: Decodable {
    private enum CodingKeys: CodingKey {
        case reasonTemplateId
        case reasonMessage
        case amount
        case importance
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let reasonTemplateId = try container.decodeIfPresent(UUID.self, forKey: .reasonTemplateId) {
            self = .template(reasonTemplateId: reasonTemplateId)
            return
        }
        
        let reasonMessage = try container.decode(String.self, forKey: .reasonMessage)
        let amount = try container.decode(Amount.self, forKey: .amount)
        let importance = try container.decode(Importance.self, forKey: .importance)
        self = .custom(reasonMessage: reasonMessage, amount: amount, importance: importance)
    }
}
