//
//  JSON conveniences tests.swift
//  
//
//  Created by Ben Leggiero on 2020-12-14.
//

import XCTest
import SerializationTools



class ArbitraryAppStorageTests: XCTestCase {
    
    override class func setUp() {
        ArbitraryAppStorage<Int>.clear()
    }
    
    
    func testBasicStorage() throws {
        class Shell {
            @ArbitraryAppStorage(key: "Shell.test")
            var test = Test(bool: .random(),
                            string: "This is a sting",
                            nullableString: Bool.random() ? "non-null!" : nil,
                            int: .random(in: .min ... .max),
                            nullableInt: Bool.random() ? .random(in: .min ... .max) : nil,
                            uint8: .random(in: .min ... .max),
                            float32: .random(in: -.leastNonzeroMagnitude ... .greatestFiniteMagnitude),
                            float64: .random(in: -.leastNonzeroMagnitude ... .greatestFiniteMagnitude),
                            cgFloat: .random(in: -.leastNonzeroMagnitude ... .greatestFiniteMagnitude),
                            array: Array(0...10),
                            dictionary: [:],
                            date: Date().roundedToNearestSecond,
                            data: "❄️☃️🪟🥰☕️🎄".data(using: .utf8)!,
                            custom: .init(content: "🍻"))
        }
    }
    
    
    static let allTests = [
        ("testBasicStorage", testBasicStorage),
    ]
}
