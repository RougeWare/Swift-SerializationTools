//
//  CodableBridge tests.swift
//  SerializationTools
//
//  Created by S🌟System on 2022-12-13.
//
import XCTest
import SerializationTools

#if canImport(AppKit)
    import AppKit
#endif
#if canImport(UIKit)
    import UIKit
#endif



class CodableBridgeTests: XCTestCase {
    
    #if canImport(AppKit)
    func testNsColor_rgb() throws {
        let raw = NSColor(red: 0.7, green: 0.5, blue: 0.2, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testNsColor_rgb_dp3() throws {
        let raw = NSColor.init(displayP3Red: 0.7, green: 0.5, blue: 0.2, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testNsColor_hsl() throws {
        let raw = NSColor(hue: 0.123, saturation: 0.8, brightness: 0.7, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testNsColor_white() throws {
        let raw = NSColor(white: 0.42, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testNsColor_system() throws {
        let raw = NSColor.systemRed
        let jsonString = try raw.codable.jsonString()
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testNsColor_system_lightDark() throws {
        let light = NSAppearance(named: .aqua)
        let dark = NSAppearance(named: .darkAqua)
        
        NSAppearance.current = light
        
        let raw = NSColor.labelColor
        let jsonString = try raw.codable.jsonString()
        
        NSAppearance.current = dark
        
        let decoded = try NSColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    @available(macOS 11, *)
    func testNsImage_accessingFields() throws {
        let bridge = try XCTUnwrap(NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: "Example text")).codable
        XCTAssertTrue((15...16).contains(bridge.size.width)) // Old macOS has 16x16, new macOS has 15x17
        XCTAssertTrue((16...17).contains(bridge.size.height)) // Old macOS has 16x16, new macOS has 15x17
        XCTAssertEqual(bridge.accessibilityDescription, "Example text")
    }
    #endif
    
    
    #if canImport(UIKit)
    func testUiColor_rgb() throws {
        let raw = UIColor(red: 0.7, green: 0.5, blue: 0.2, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testUiColor_rgb_dp3() throws {
        let raw = UIColor.init(displayP3Red: 0.7, green: 0.5, blue: 0.2, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testUiColor_hsl() throws {
        let raw = UIColor(hue: 0.123, saturation: 0.8, brightness: 0.7, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testUiColor_white() throws {
        let raw = UIColor(white: 0.42, alpha: 1)
        let jsonString = try raw.codable.jsonString()
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    func testUiColor_system() throws {
        let raw = UIColor.systemRed
        let jsonString = try raw.codable.jsonString()
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    @available(iOS 13.0, *)
    func testNsColor_system_lightDark() throws {
        UITraitCollection.current = .init(userInterfaceStyle: .light)
        
        let raw = UIColor.label
        let jsonString = try raw.codable.jsonString()
        
        UITraitCollection.current = .init(userInterfaceStyle: .dark)
        
        let decoded = try UIColor.CodableBridge(jsonString: jsonString).value
        XCTAssertEqual(raw, decoded)
    }
    
    @available(iOS 13.0, *)
    func testUiImage_accessingFields() throws {
        let bridge = try XCTUnwrap(UIImage(systemName: "square.and.arrow.up")).codable
        XCTAssertEqual(bridge.size.width, 19)
        XCTAssertEqual(bridge.size.height, 21)
    }
    #endif
}
