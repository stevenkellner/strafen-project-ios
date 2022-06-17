import XCTest
@testable import FirebaseInterface

fileprivate func parseType<T>(_ type: T.Type, from json: String) throws -> T where T: Decodable {
    let data = json.data(using: .utf8)
    XCTAssertNotNil(data)
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(T.self, from: data!)
}

final class TypeDefinitionsTests: XCTestSuite {
    final class AmountTests: XCTestCase {
        func testValueNoNumber() {
            XCTAssertThrowsError(try parseType(Amount.self, from: #""12.50""#))
        }
        
        func testValueNegativeNumber() {
            XCTAssertThrowsError(try parseType(Amount.self, from: "-12.50"))
        }
        
        func testValueZeroNumber() throws {
            let amount = try parseType(Amount.self, from: "0.0")
            XCTAssertEqual(amount, Amount(value: 0, subUnitValue: 0))
            XCTAssertEqual(amount.internalParameter, 0.0)
        }
        
        func testValueLargeSubunitValue() throws {
            let amount = try parseType(Amount.self, from: "1.298")
            XCTAssertEqual(amount, Amount(value: 1, subUnitValue: 29))
            XCTAssertEqual(amount.internalParameter, 1.29)
        }
        
        func testValueNoSubunitValue() throws {
            let amount = try parseType(Amount.self, from: "34")
            XCTAssertEqual(amount, Amount(value: 34, subUnitValue: 0))
            XCTAssertEqual(amount.internalParameter, 34.0)
        }
    }
    
    final class ChangeTypeTests: XCTestCase {
        func testValueNoString() {
            XCTAssertThrowsError(try parseType(ChangeType.self, from: "12.5"))
        }
        
        func testInvalidValue() {
            XCTAssertThrowsError(try parseType(ChangeType.self, from: #""invalid""#))
        }
        
        func testValueUpdate() throws {
            let changeType = try parseType(ChangeType.self, from: #""update""#)
            XCTAssertEqual(changeType, .update)
            XCTAssertEqual(changeType.internalParameter, "update")
        }
        
        func testValueDelete() throws {
            let changeType = try parseType(ChangeType.self, from: #""delete""#)
            XCTAssertEqual(changeType, .delete)
            XCTAssertEqual(changeType.internalParameter, "delete")
        }
    }
    
    final class ClubPropertiesTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(ClubProperties.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(ClubProperties.self, from: "{}"))
        }
        
        func testInvalidId() {
            XCTAssertThrowsError(try parseType(ClubProperties.self, from: """
                {
                    "id": "invalid",
                    "name": "test name",
                    "identifier": "test identifier",
                    "regionCode": "test region code",
                    "inAppPaymentActive": true
                }
            """))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let clubProperties = try parseType(ClubProperties.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "name": "test name",
                    "identifier": "test identifier",
                    "regionCode": "test region code",
                    "inAppPaymentActive": true
                }
            """)
            XCTAssertEqual(clubProperties, ClubProperties(id: id, name: "test name", identifier: "test identifier", regionCode: "test region code", inAppPaymentActive: true))
            XCTAssertEqual(clubProperties.internalParameter, [
                "id": .string(id.uuidString),
                "name": "test name",
                "identifier": "test identifier",
                "regionCode": "test region code",
                "inAppPaymentActive": true
            ])
        }
    }
    
    final class DatabaseTypeTests: XCTestCase {
        func testValueNoString() {
            XCTAssertThrowsError(try parseType(DatabaseType.self, from: "12.5"))
        }
        
        func testInvalidValue() {
            XCTAssertThrowsError(try parseType(DatabaseType.self, from: #""invalid""#))
        }
        
        func testValueRelease() throws {
            let changeType = try parseType(DatabaseType.self, from: #""release""#)
            XCTAssertEqual(changeType, .release)
            XCTAssertEqual(changeType.internalParameter, "release")
        }
        
        func testValueDebug() throws {
            let changeType = try parseType(DatabaseType.self, from: #""debug""#)
            XCTAssertEqual(changeType, .debug)
            XCTAssertEqual(changeType.internalParameter, "debug")
        }
        
        func testValueTesting() throws {
            let changeType = try parseType(DatabaseType.self, from: #""testing""#)
            XCTAssertEqual(changeType, .testing)
            XCTAssertEqual(changeType.internalParameter, "testing")
        }
    }
    
    final class DeletableTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(Deletable<Amount, UUID>.self, from: #""asdf""#) as Deletable<Amount, UUID>)
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(Deletable<Amount, UUID>.self, from: "{}") as Deletable<Amount, UUID>)
        }
        
        func testDeletedFalseNoItem() {
            XCTAssertThrowsError(try parseType(Deletable<Amount, UUID>.self, from: """
                    {
                        "id": "\(UUID().uuidString)",
                        "deleted": false
                    }
            """) as Deletable<Amount, UUID>)
        }
        
        func testDeletedFalse() throws {
            let id = UUID()
            let deletable: Deletable<ClubProperties, UUID> = try parseType(Deletable<ClubProperties, UUID>.self, from: """
                    {
                        "id": "\(id.uuidString)",
                        "deleted": false,
                        "name": "test name",
                        "identifier": "test identifier",
                        "regionCode": "test region code",
                        "inAppPaymentActive": true
                    }
            """)
            XCTAssertEqual(deletable, Deletable<ClubProperties, UUID>.item(ClubProperties(id: id, name: "test name", identifier: "test identifier", regionCode: "test region code", inAppPaymentActive: true)))
            XCTAssertEqual(deletable.internalParameter, [
                "id": .string(id.uuidString),
                "name": "test name",
                "identifier": "test identifier",
                "regionCode": "test region code",
                "inAppPaymentActive": true
            ])
        }
        
        func testDeletedNoId() {
            XCTAssertThrowsError(try parseType(Deletable<Amount, UUID>.self, from: """
                    {
                        "deleted": true
                    }
            """) as Deletable<Amount, UUID>)
        }
        
        func testDeletedTrue1() throws {
            let id = UUID()
            let deletable: Deletable<Amount, UUID> = try parseType(Deletable<Amount, UUID>.self, from: """
                    {
                        "id": "\(id.uuidString)",
                        "deleted": true
                    }
            """)
            XCTAssertEqual(deletable, Deletable<Amount, UUID>.deleted(id: id))
        }
        
        func testDeletedTrue2() throws {
            let id = UUID()
            let deletable: Deletable<ClubProperties, UUID> = try parseType(Deletable<ClubProperties, UUID>.self, from: """
                    {
                        "id": "\(id.uuidString)",
                        "deleted": true
                    }
            """)
            XCTAssertEqual(deletable, Deletable<ClubProperties, UUID>.deleted(id: id))
            XCTAssertEqual(deletable.internalParameter, [
                "id": .string(id.uuidString),
                "deleted": true
            ])
        }
        
        func testItem() throws {
            let id = UUID()
            let deletable: Deletable<ClubProperties, UUID> = try parseType(Deletable<ClubProperties, UUID>.self, from: """
                    {
                        "id": "\(id.uuidString)",
                        "name": "test name",
                        "identifier": "test identifier",
                        "regionCode": "test region code",
                        "inAppPaymentActive": true
                    }
            """)
            XCTAssertEqual(deletable, Deletable<ClubProperties, UUID>.item(ClubProperties(id: id, name: "test name", identifier: "test identifier", regionCode: "test region code", inAppPaymentActive: true)))
            XCTAssertEqual(deletable.internalParameter, [
                "id": .string(id.uuidString),
                "name": "test name",
                "identifier": "test identifier",
                "regionCode": "test region code",
                "inAppPaymentActive": true
            ])
        }
    }
    
    final class FineTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(Fine.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(Fine.self, from: "{}"))
        }
                
        func testValueValid() throws {
            let id = UUID()
            let personId = UUID()
            let updatePersonId = UUID()
            let reasonTemplateId = UUID()
            let updateTimestamp = Date()
            let date = Date()
            let fine = try parseType(Fine.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "personId": "\(personId.uuidString)",
                    "payedState": {
                        "state": "settled",
                        "updateProperties": {
                            "timestamp": "\(updateTimestamp.ISO8601Format(.iso8601))",
                            "personId": "\(updatePersonId.uuidString)"
                        }
                    },
                    "number": 1,
                    "date": "\(date.ISO8601Format(.iso8601))",
                    "fineReason": {
                        "reasonTemplateId": "\(reasonTemplateId.uuidString)"
                    }
                }
            """)
            XCTAssertEqual(fine, Fine(id: id, personId: personId, payedState: Updatable(property: .settled, updateProperties: Updatable.UpdateProperties(timestamp: updateTimestamp, personId: updatePersonId)), number: 1, date: date, fineReason: .template(reasonTemplateId: reasonTemplateId)))
            XCTAssertEqual(fine.internalParameter, [
                "id": .string(id.uuidString),
                "personId": .string(personId.uuidString),
                "payedState": [
                    "state": "settled",
                    "updateProperties": [
                        "timestamp": .string(updateTimestamp.ISO8601Format(.iso8601)),
                        "personId": .string(updatePersonId.uuidString)
                    ]
                ],
                "number": 1,
                "date": .string(date.ISO8601Format(.iso8601)),
                "fineReason": [
                    "reasonTemplateId": .string(reasonTemplateId.uuidString)
                ]
            ])
        }
    }
        
    final class FineReasonTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(FineReason.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(FineReason.self, from: "{}"))
        }
        
        func testValueCustomAndTemplate() throws {
            let reasonTemplateId = UUID()
            let fineReason = try parseType(FineReason.self, from: """
                {
                    "reasonTemplateId": "\(reasonTemplateId.uuidString)",
                    "reasonMessage": "asdf",
                    "amount": 12.50,
                    "importance": "high"
                }
            """)
            XCTAssertEqual(fineReason, FineReason.template(reasonTemplateId: reasonTemplateId))
            XCTAssertEqual(fineReason.internalParameter, [
                "reasonTemplateId": .string(reasonTemplateId.uuidString)
            ])
        }
        
        func testValueTemplate() throws {
            let reasonTemplateId = UUID()
            let fineReason = try parseType(FineReason.self, from: """
                {
                    "reasonTemplateId": "\(reasonTemplateId.uuidString)"
                }
            """)
            XCTAssertEqual(fineReason, FineReason.template(reasonTemplateId: reasonTemplateId))
            XCTAssertEqual(fineReason.internalParameter, [
                "reasonTemplateId": .string(reasonTemplateId.uuidString)
            ])
        }
        
        func testValueCustom() throws {
            let fineReason = try parseType(FineReason.self, from: """
                {
                    "reasonMessage": "asdf",
                    "amount": 12.50,
                    "importance": "high"
                }
            """)
            XCTAssertEqual(fineReason, FineReason.custom(reasonMessage: "asdf", amount: Amount(value: 12, subUnitValue: 50), importance: .high))
            XCTAssertEqual(fineReason.internalParameter, [
                "reasonMessage": "asdf",
                "amount": 12.50,
                "importance": "high"
            ])
        }
    }
    
    final class ImportanceTests: XCTestCase {
        func testNoString() {
            XCTAssertThrowsError(try parseType(Importance.self, from: "12.50"))
        }
        
        func testInvalidString() {
            XCTAssertThrowsError(try parseType(Importance.self, from: #""asdf""#))
        }
        
        func testValueHigh() throws {
            let importance = try parseType(Importance.self, from: #""high""#)
            XCTAssertEqual(importance, Importance.high)
            XCTAssertEqual(importance.internalParameter, "high")
        }
        
        func testValueMedium() throws {
            let importance = try parseType(Importance.self, from: #""medium""#)
            XCTAssertEqual(importance, Importance.medium)
            XCTAssertEqual(importance.internalParameter, "medium")
        }
        
        func testValueLow() throws {
            let importance = try parseType(Importance.self, from: #""low""#)
            XCTAssertEqual(importance, Importance.low)
            XCTAssertEqual(importance.internalParameter, "low")
        }
    }
    
    final class LatePaymentInterestTests: XCTestCase {
        func testTimePeriodNoObject() {
            XCTAssertThrowsError(try parseType(LatePaymentInterest.TimePeriod.self, from: "12.50"))
        }
        
        func testTimePeriodInvalidObject() {
            XCTAssertThrowsError(try parseType(LatePaymentInterest.TimePeriod.self, from: "{}"))
        }
        
        func testTimePeriodInvalidUnit() {
            XCTAssertThrowsError(try parseType(LatePaymentInterest.TimePeriod.self, from: """
                {
                    "value": 12,
                    "unit": "asdf"
                }
            """))
        }
        
        func testTimePeriodUnitDay() throws {
            let timePeriod = try parseType(LatePaymentInterest.TimePeriod.self, from: """
                {
                    "value": 12,
                    "unit": "day"
                }
            """)
            XCTAssertEqual(timePeriod, LatePaymentInterest.TimePeriod(value: 12, unit: .day))
            XCTAssertEqual(timePeriod.internalParameter, [
                "value": 12,
                "unit": "day"
            ])
        }
        
        func testTimePeriodUnitMonth() throws {
            let timePeriod = try parseType(LatePaymentInterest.TimePeriod.self, from: """
                {
                    "value": 12,
                    "unit": "month"
                }
            """)
            XCTAssertEqual(timePeriod, LatePaymentInterest.TimePeriod(value: 12, unit: .month))
            XCTAssertEqual(timePeriod.internalParameter, [
                "value": 12,
                "unit": "month"
            ])
        }
        
        func testTimePeriodUnitYear() throws {
            let timePeriod = try parseType(LatePaymentInterest.TimePeriod.self, from: """
                {
                    "value": 12,
                    "unit": "year"
                }
            """)
            XCTAssertEqual(timePeriod, LatePaymentInterest.TimePeriod(value: 12, unit: .year))
            XCTAssertEqual(timePeriod.internalParameter, [
                "value": 12,
                "unit": "year"
            ])
        }
        
        func testNoObject() {
            XCTAssertThrowsError(try parseType(LatePaymentInterest.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(LatePaymentInterest.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let latePaymentInterest = try parseType(LatePaymentInterest.self, from: """
                {
                    "interestFreePeriod": {
                        "value": 10,
                        "unit": "day"
                    },
                    "interestPeriod": {
                        "value": 2,
                        "unit": "year"
                    },
                    "interestRate": 1.2,
                    "compoundInterest": true
                }
            """)
            XCTAssertEqual(latePaymentInterest, LatePaymentInterest(interestFreePeriod: LatePaymentInterest.TimePeriod(value: 10, unit: .day), interestPeriod: LatePaymentInterest.TimePeriod(value: 2, unit: .year), interestRate: 1.2, compoundInterest: true))
            XCTAssertEqual(latePaymentInterest.internalParameter, [
                "interestFreePeriod": [
                    "value": 10,
                    "unit": "day"
                ],
                "interestPeriod": [
                    "value": 2,
                    "unit": "year"
                ],
                "interestRate": 1.2,
                "compoundInterest": true
            ])
        }
    }
    
    final class PayedStateTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(PayedState.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(PayedState.self, from: "{}"))
        }
        
        func testValueUnpayed() throws {
            let payedState = try parseType(PayedState.self, from: """
                {
                    "state": "unpayed"
                }
            """)
            XCTAssertEqual(payedState, PayedState.unpayed)
            XCTAssertEqual(payedState.internalParameter, [
                "state": "unpayed"
            ])
        }
        
        func testValueSettled() throws {
            let payedState = try parseType(PayedState.self, from: """
                {
                    "state": "settled"
                }
            """)
            XCTAssertEqual(payedState, PayedState.settled)
            XCTAssertEqual(payedState.internalParameter, [
                "state": "settled"
            ])
        }
        
        func testValuePayed() throws {
            let payDate = Date()
            let payedState = try parseType(PayedState.self, from: """
                {
                    "state": "payed",
                    "inApp": true,
                    "payDate": "\(payDate.ISO8601Format(.iso8601))"
                }
            """)
            XCTAssertEqual(payedState, PayedState.payed(inApp: true, payDate: payDate))
            XCTAssertEqual(payedState.internalParameter, [
                "state": "payed",
                "inApp": true,
                "payDate": .string(payDate.ISO8601Format(.iso8601))
            ])
        }
    }
    
    final class PersonTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(Person.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(Person.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let person = try parseType(Person.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "name": {
                        "first": "asdf",
                        "last": "ölkj"
                    }
                }
            """)
            XCTAssertEqual(person, Person(id: id, name: PersonName(first: "asdf", last: "ölkj")))
            XCTAssertEqual(person.internalParameter, [
                "id": .string(id.uuidString),
                "name": [
                    "first": "asdf",
                    "last": .optional("ölkj")
                ]
            ])
        }
    }
    
    final class PersonNameTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(PersonName.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(PersonName.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let personName = try parseType(PersonName.self, from: """
                {
                    "first": "g",
                    "last": "f"
                }
            """)
            XCTAssertEqual(personName, PersonName(first: "g", last: "f"))
            XCTAssertEqual(personName.internalParameter, [
                "first": "g",
                "last": .optional("f")
            ])
        }
        
        func testValueValidNoLast() throws {
            let personName = try parseType(PersonName.self, from: """
                {
                    "first": "h"
                }
            """)
            XCTAssertEqual(personName, PersonName(first: "h"))
            XCTAssertEqual(personName.internalParameter, [
                "first": "h",
                "last": nil
            ])
        }
    }
    
    final class PersonPropertiesWithIsAdminTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(PersonPropertiesWithIsAdmin.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(PersonPropertiesWithIsAdmin.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let signInDate = Date()
            let personProperties = try parseType(PersonPropertiesWithIsAdmin.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "signInDate": "\(signInDate.ISO8601Format(.iso8601))",
                    "isAdmin": true,
                    "name": {
                        "first": "asdf"
                    }
                }
            """)
            XCTAssertEqual(personProperties, PersonPropertiesWithIsAdmin(id: id, signInDate: signInDate, isAdmin: true, name: PersonName(first: "asdf")))
            XCTAssertEqual(personProperties.internalParameter, [
                "id": .string(id.uuidString),
                "signInDate": .string(signInDate.ISO8601Format(.iso8601)),
                "isAdmin": true,
                "name": [
                    "first": "asdf",
                    "last": nil
                ]
            ])
        }
    }
    
    final class PersonPropertiesWithUserIdTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(PersonPropertiesWithUserId.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(PersonPropertiesWithUserId.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let signInDate = Date()
            let personProperties = try parseType(PersonPropertiesWithUserId.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "signInDate": "\(signInDate.ISO8601Format(.iso8601))",
                    "userId": "ölkj",
                    "name": {
                        "first": "asdf"
                    }
                }
            """)
            XCTAssertEqual(personProperties, PersonPropertiesWithUserId(id: id, signInDate: signInDate, userId: "ölkj", name: PersonName(first: "asdf")))
            XCTAssertEqual(personProperties.internalParameter, [
                "id": .string(id.uuidString),
                "signInDate": .string(signInDate.ISO8601Format(.iso8601)),
                "userId": "ölkj",
                "name": [
                    "first": "asdf",
                    "last": nil
                ]
            ])
        }
    }
    
    final class ReasonTemplateTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(ReasonTemplate.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(ReasonTemplate.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let reasonTemplate = try parseType(ReasonTemplate.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "reasonMessage": "message",
                    "amount": 23.45,
                    "importance": "high"
                }
            """)
            XCTAssertEqual(reasonTemplate, ReasonTemplate(id: id, reasonMessage: "message", amount: Amount(value: 23, subUnitValue: 45), importance: .high))
            XCTAssertEqual(reasonTemplate.internalParameter, [
                "id": .string(id.uuidString),
                "reasonMessage": "message",
                "amount": 23.45,
                "importance": "high"
            ])
        }
    }
    
    final class UpdatableTests: XCTestCase {
        func testNoObject() {
            XCTAssertThrowsError(try parseType(Updatable<Person>.self, from: "12.50"))
        }
        
        func testInvalidObject() {
            XCTAssertThrowsError(try parseType(Updatable<Person>.self, from: "{}"))
        }
        
        func testValueValid() throws {
            let id = UUID()
            let personId = UUID()
            let timestamp = Date()
            let updatable = try parseType(Updatable<Person>.self, from: """
                {
                    "id": "\(id.uuidString)",
                    "name": {
                        "first": "fn",
                        "last": "ln"
                    },
                    "updateProperties": {
                        "personId": "\(personId.uuidString)",
                        "timestamp": "\(timestamp.ISO8601Format(.iso8601))"
                    }
                }
            """)
            XCTAssertEqual(updatable, Updatable(property: Person(id: id, name: PersonName(first: "fn", last: "ln")), updateProperties: Updatable.UpdateProperties(timestamp: timestamp, personId: personId)))
            XCTAssertEqual(updatable.internalParameter, [
                "id": .string(id.uuidString),
                "name": [
                    "first": "fn",
                    "last": .optional("ln")
                ],
                "updateProperties": [
                    "personId": .string(personId.uuidString),
                    "timestamp": .string(timestamp.ISO8601Format(.iso8601))
                ]
            ])
        }
    }
}
