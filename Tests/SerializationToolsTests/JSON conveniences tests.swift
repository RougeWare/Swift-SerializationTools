//
//  JSON conveniences tests.swift
//  
//
//  Created by Ben Leggiero on 2020-12-14.
//

import XCTest
import SerializationTools



class JsonConveniencesTests: XCTestCase {
    
    func testSerializingToAndFromJsonData() throws {
        let original = Test(
            bool: true,
            string: "Strung",
            nullableString: nil,
            int: 7,
            nullableInt: nil,
            uint8: 42,
            float32: 525600,
            float64: 3.14159,
            cgFloat: 2.71828,
            array: [2, 4, 6, 8],
            dictionary: [
                "Black" : "Sphinx",
                "of" : "quartz",
                "judge" : "my vow",
            ],
            date: Date().roundedToNearestSecond, // This is acceptable for these tests
            data: "Swift 🧡💛 JSON".data(using: .utf16)!,
            custom: Test.Custom(content: "Quite content indeed")
        )
        
        let jsonData = try! original.jsonData()
        let reconstructed = try! Test(jsonData: jsonData)
        
        XCTAssertEqual(original, reconstructed)
    }
    
    
    func testSerializingToAndFromJsonString() throws {
        let original = Test(
            bool: false,
            string: "låmp",
            nullableString: "❄️",
            int: -40,
            nullableInt: 29,
            uint8: 0,
            float32: .infinity,
            float64: .nan,
            cgFloat: .leastNonzeroMagnitude,
            array: [1, 1, 2, 3, 5, 8, 13],
            dictionary: [
                "Five" : "quacking",
                "zephyrs" : "jolt",
                "my" : "wax bed",
            ],
            date: Date(timeIntervalSinceReferenceDate: 0).roundedToNearestSecond,
            data: "🥰☕️🪟☃️🎄".data(using: .utf8)!,
            custom: Test.Custom(content: "Quite content indeed")
        )
        
        let jsonString = try! original.jsonString()
        let reconstructed = try! Test(jsonString: jsonString)
        
        XCTAssertEqual(original, reconstructed)
    }
    
    
    static let allTests = [
        ("testSerializingToAndFromJsonData", testSerializingToAndFromJsonData),
        ("testSerializingToAndFromJsonString", testSerializingToAndFromJsonString),
    ]
}



private extension Date {
    var roundedToNearestSecond: Date {
        Date(timeIntervalSinceReferenceDate: self.timeIntervalSinceReferenceDate.rounded())
    }
}



private struct Test: Codable, Equatable {
    let bool: Bool
    let string: String
    let nullableString: String?
    let int: Int
    let nullableInt: Int?
    let uint8: UInt8
    let float32: Float32
    let float64: Float64
    let cgFloat: CGFloat
    let array: [Int]
    let dictionary: [String : String]
    let date: Date
    let data: Data
    let custom: Custom
    
    struct Custom: Codable, Equatable {
        let content: String
    }
    
    
    
    /// Gotta do this because `.nan != .nan`, always ☹️
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.bool == rhs.bool
            && lhs.string == rhs.string
            && lhs.nullableString == rhs.nullableString
            && lhs.int == rhs.int
            && lhs.nullableInt == rhs.nullableInt
            && lhs.uint8 == rhs.uint8
            && lhs.float32 ~== rhs.float32
            && lhs.float64 ~== rhs.float64
            && lhs.cgFloat ~== rhs.cgFloat
            && lhs.array == rhs.array
            && lhs.dictionary == rhs.dictionary
            && lhs.date == rhs.date
            && lhs.data == rhs.data
            && lhs.custom == rhs.custom
    }
}



infix operator ~== : ComparisonPrecedence



extension FloatingPoint {
    static func ~==(lhs: Self, rhs: Self) -> Bool {
        return lhs == rhs
            || (lhs.isNaN && rhs.isNaN)
    }
}
