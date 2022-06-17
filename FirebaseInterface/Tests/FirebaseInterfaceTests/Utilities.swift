//
//  Utilities.swift
//  
//
//  Created by Steven on 14.06.22.
//

import Foundation
@testable import FirebaseInterface

extension InternalFunctionParameterType: Equatable {
    public static func ==(lhs: InternalFunctionParameterType, rhs: InternalFunctionParameterType) -> Bool {
        switch (lhs, rhs) {
        case (.bool(let lhsValue), .bool(let rhsValue)):
            return lhsValue == rhsValue
        case (.int(let lhsValue), .int(let rhsValue)):
            return lhsValue == rhsValue
        case (.uint(let lhsValue), .uint(let rhsValue)):
            return lhsValue == rhsValue
        case (.double(let lhsValue), .double(let rhsValue)):
            return lhsValue == rhsValue
        case (.float(let lhsValue), .float(let rhsValue)):
            return lhsValue == rhsValue
        case (.string(let lhsValue), .string(let rhsValue)):
            return lhsValue == rhsValue
        case (.optional(let lhsValue), .optional(let rhsValue)):
            return lhsValue == rhsValue
        case (.array(let lhsValue), .array(let rhsValue)):
            return lhsValue == rhsValue
        case (.dictionary(let lhsValue), .dictionary(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}

extension InternalFunctionParameterType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bool(let value):
            return String(describing: value)
        case .int(let value):
            return String(describing: value)
        case .uint(let value):
            return String(describing: value)
        case .double(let value):
            return String(describing: value)
        case .float(let value):
            return String(describing: value)
        case .string(let value):
            return String(describing: value)
        case .optional(let value):
            return String(describing: value.map(\.firebaseFunctionParameter))
        case .array(let value):
            return String(describing: value.map(\.firebaseFunctionParameter))
        case .dictionary(let value):
            return String(describing: value.mapValues(\.firebaseFunctionParameter))
        }
    }
}

extension InternalFunctionParameterType: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) {
        self = .bool(value)
    }
}

extension InternalFunctionParameterType: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) {
        self = .int(value)
    }
}

extension InternalFunctionParameterType: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) {
        self = .double(value)
    }
}

extension InternalFunctionParameterType: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = .string(value)
    }
}

extension InternalFunctionParameterType: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .optional(nil)
    }
}

extension InternalFunctionParameterType: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: InternalFunctionParameterType...) {
        self = .array(elements)
    }
}

extension InternalFunctionParameterType: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, InternalFunctionParameterType)...) {
        self = .dictionary(Dictionary(elements) { _, value in value })
    }
}

extension Amount: Equatable {
    public static func ==(lhs: Amount, rhs: Amount) -> Bool {
        return lhs.value == rhs.value &&
        lhs.subUnitValue == rhs.subUnitValue
    }
}

extension ClubProperties: Equatable {
    public static func ==(lhs: ClubProperties, rhs: ClubProperties) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.identifier == rhs.identifier &&
        lhs.regionCode == rhs.regionCode &&
        lhs.inAppPaymentActive == rhs.inAppPaymentActive
    }
}

extension Deletable: Equatable where T: Equatable, ID: Equatable {
    public static func ==(lhs: Deletable<T, ID>, rhs: Deletable<T, ID>) -> Bool {
        switch (lhs, rhs) {
        case (.deleted(id: let lhsId), .deleted(id: let rhsId)):
            return lhsId == rhsId
        case (.item(let lhsItem), .item(let rhsItem)):
            return lhsItem == rhsItem
        default:
            return false
        }
    }
}

extension Fine: Equatable {
    public static func ==(lhs: Fine, rhs: Fine) -> Bool {
        return lhs.id == rhs.id &&
            lhs.personId == rhs.personId &&
            Calendar.current.isDate(lhs.date, equalTo: rhs.date, toGranularity: .nanosecond) &&
            lhs.fineReason == rhs.fineReason &&
            lhs.number == rhs.number &&
            lhs.payedState == rhs.payedState
    }
}

extension FineReason: Equatable {
    public static func ==(lhs: FineReason, rhs: FineReason) -> Bool {
        switch (lhs, rhs) {
        case (.template(reasonTemplateId: let lhsReasonTemplateId), .template(reasonTemplateId: let rhsReasonTemplateId)):
            return lhsReasonTemplateId == rhsReasonTemplateId
        case (.custom(reasonMessage: let lhsReasonMessage, amount: let lhsAmount, importance: let lhsImportance), .custom(reasonMessage: let rhsReasonMessage, amount: let rhsAmount, importance: let rhsImportance)):
            return lhsReasonMessage == rhsReasonMessage &&
                lhsAmount == rhsAmount &&
                lhsImportance == rhsImportance
        default:
            return false
        }
    }
}

extension PayedState: Equatable {
    public static func ==(lhs: PayedState, rhs: PayedState) -> Bool {
        switch (lhs, rhs) {
        case (.payed(inApp: let lhsInApp, payDate: let lhsPayDate), .payed(inApp: let rhsInApp, payDate: let rhsPayDate)):
            return lhsInApp == rhsInApp &&
                Calendar.current.isDate(lhsPayDate, equalTo: rhsPayDate, toGranularity: .nanosecond)
        case (.unpayed, .unpayed):
            return true
        case (.settled, .settled):
            return true
        default:
            return false
        }
    }
}

extension Updatable.UpdateProperties: Equatable {
    public static func ==(lhs: Updatable.UpdateProperties, rhs: Updatable.UpdateProperties) -> Bool {
        return Calendar.current.isDate(lhs.timestamp, equalTo: rhs.timestamp, toGranularity: .nanosecond) &&
            lhs.personId == rhs.personId
    }
}

extension Updatable: Equatable where T: Equatable {
    public static func ==(lhs: Updatable<T>, rhs: Updatable<T>) -> Bool {
        return lhs.property == rhs.property &&
            lhs.updateProperties == rhs.updateProperties
    }
}

extension LatePaymentInterest.TimePeriod: Equatable {
    public static func ==(lhs: LatePaymentInterest.TimePeriod, rhs: LatePaymentInterest.TimePeriod) -> Bool {
        return lhs.value == rhs.value &&
            lhs.unit == rhs.unit
    }
}

extension LatePaymentInterest: Equatable {
    public static func ==(lhs: LatePaymentInterest, rhs: LatePaymentInterest) -> Bool {
        return lhs.interestFreePeriod == rhs.interestFreePeriod &&
            lhs.interestPeriod == rhs.interestPeriod &&
            lhs.interestRate == rhs.interestRate &&
            lhs.compoundInterest == rhs.compoundInterest
    }
}

extension PersonName: Equatable {
    public static func ==(lhs: PersonName, rhs: PersonName) -> Bool {
        return lhs.first == rhs.first &&
            lhs.last == rhs.last
    }
}

extension Person: Equatable {
    public static func ==(lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}

extension PersonPropertiesWithIsAdmin: Equatable {
    public static func ==(lhs: PersonPropertiesWithIsAdmin, rhs: PersonPropertiesWithIsAdmin) -> Bool {
        return lhs.id == rhs.id &&
            Calendar.current.isDate(lhs.signInDate, equalTo: rhs.signInDate, toGranularity: .nanosecond) &&
            lhs.name == rhs.name &&
            lhs.isAdmin == rhs.isAdmin
    }
}

extension PersonPropertiesWithUserId: Equatable {
    public static func ==(lhs: PersonPropertiesWithUserId, rhs: PersonPropertiesWithUserId) -> Bool {
        return lhs.id == rhs.id &&
            Calendar.current.isDate(lhs.signInDate, equalTo: rhs.signInDate, toGranularity: .nanosecond) &&
            lhs.name == rhs.name &&
            lhs.userId == rhs.userId
    }
}

extension ReasonTemplate: Equatable {
    public static func ==(lhs: ReasonTemplate, rhs: ReasonTemplate) -> Bool {
        return lhs.id == rhs.id &&
            lhs.reasonMessage == rhs.reasonMessage &&
            lhs.amount == rhs.amount &&
            lhs.importance == rhs.importance
    }
}

