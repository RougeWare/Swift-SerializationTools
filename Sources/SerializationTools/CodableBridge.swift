//
//  CodableBridge.swift
//  SerializationTools
//
//  Created by S🌟System on 2022-12-11.
//

import Foundation



/// Allows you to use Swift encoders and decoders to process an `NSCoding` type
@dynamicMemberLookup
public struct CodableBridge<BaseType: NSCoding> {

    /// The value to be (en/de)coded
    public var value: BaseType
    
    
    public init(value: BaseType) {
        self.value = value
    }
}



public extension CodableBridge {
    subscript<T>(dynamicMember keyPath: KeyPath<BaseType, T>) -> T {
        value[keyPath: keyPath]
    }
    
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<BaseType, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }
}



// MARK: - Codable

@available(macOS 10.13, *)
@available(iOS 11, *)
extension CodableBridge: Encodable {
    public func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        value.encode(with: nsCoder)
        var container = encoder.singleValueContainer()
        try container.encode(nsCoder.encodedData)
    }
}



@available(macOS 10.13, *)
@available(iOS 11, *)
extension CodableBridge: Decodable {
    public init(from decoder: Decoder) throws {
        self.init(value: try BaseType(coder: try Self.nsCoder(from: decoder)).unwrappedOrThrow())
    }
    
    
    
    public static func nsCoder(from decoder: Decoder) throws -> NSCoder {
        let container = try decoder.singleValueContainer()
        let decodedData = try container.decode(Data.self)
        return try NSKeyedUnarchiver(forReadingFrom: decodedData)
    }
}



// MARK: - Sugar on NSCoding

public extension NSCoding {
    
    /// A version of this object that can be used with Swift's built-in `Codable` system
    var codable: CodableBridge {
        CodableBridge(value: self)
    }
    
    
    typealias CodableBridge = SerializationTools.CodableBridge<Self>
}



@available(macOS 10.13, *)
@available(iOS 11, *)
public extension NSCoding where Self: Encodable {
    func encode(to encoder: Encoder) throws {
        try self.codable.encode(to: encoder)
    }
}



@available(macOS 10.13, *)
@available(iOS 11, *)
public extension NSCoding where Self: Decodable {
    /// This function allows you to easily decode an `NSCoding` instance
    ///
    /// This was made because `init(from:)` cannot be synthesized due to Swift's compile-time requirements for extensions on reference types
    ///
    /// - Parameter decoder: The swift decoder which will be decoding the instance
    static func decode(from decoder: Decoder) throws -> Self {
        try Self.init(coder: try CodableBridge.nsCoder(from: decoder)).unwrappedOrThrow()
    }
}
