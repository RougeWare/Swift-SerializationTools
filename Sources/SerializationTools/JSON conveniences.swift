//
//  JSON conveniences.swift
//  
//
//  Created by Ben Leggiero on 2020-12-14.
//

import Foundation
import OptionalTools



// MARK: - Encoding

public extension Encodable {
    
    /// Encodes this to JSON-formatted data. The resulting data can be further encoded into a Unicode string.
    /// See also `jsonString()`.
    ///
    /// - Parameters:
    ///   - dataEncodingStrategy:               _optional_ - How `Data` values should be encoded. Defaults to `.base64`
    ///   - dateEncodingStrategy:               _optional_ - How `Date` values should be encoded. Defaults to `.iso8601`
    ///   - keyEncodingStrategy:                _optional_ - How Swift field names should be translated to JSON keys.
    ///                                         Defaults to `.useDefaultKeys`
    ///   - nonConformingFloatEncodingStrategy: _optional_ - How numerical values should be encoded when they cannot be
    ///                                         directly represented in JSON.
    ///                                         Defaults to `.convertToJavaScriptStyleStrings`
    ///
    /// - Throws: Any error which describes why an object couldn't be encoded
    /// - Returns: JSON-encoded data form of this
    func jsonData(
        dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .convertToJavaScriptStyleStrings)
    throws -> Data {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = dataEncodingStrategy
        encoder.dateEncodingStrategy = dateEncodingStrategy
        encoder.keyEncodingStrategy = keyEncodingStrategy
        encoder.nonConformingFloatEncodingStrategy = .convertToJavaScriptStyleStrings
        return try encoder.encode(self)
    }
    
    
    /// Encodes this to a JSON-formatted string.
    /// See also `jsonData()`.
    ///
    /// - Parameters:
    ///   - dataEncodingStrategy:               _optional_ - How `Data` values should be encoded. Defaults to `.base64`
    ///   - dateEncodingStrategy:               _optional_ - How `Date` values should be encoded. Defaults to `.iso8601`
    ///   - keyEncodingStrategy:                _optional_ - How Swift field names should be translated to JSON keys.
    ///                                         Defaults to `.useDefaultKeys`
    ///   - nonConformingFloatEncodingStrategy: _optional_ - How numerical values should be encoded when they cannot be
    ///                                         directly represented in JSON.
    ///                                         Defaults to `.convertToJavaScriptStyleStrings`
    ///   - stringEncoding:                     _optional_ - How to enocde the data to a `String`. Defaults to `.utf8`
    ///
    /// - Throws: Any error which describes why an object couldn't be encoded. If this occurs outside `JSONEncoder`,
    ///           then this will be a `JsonEncodingError`
    /// - Returns: JSON-encoded string form of this
    func jsonString(
        dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .base64,
        dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .iso8601,
        keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys,
        nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy = .convertToJavaScriptStyleStrings,
        stringEncoding: String.Encoding = .utf8)
    throws -> String {
        try String(data: try jsonData(dataEncodingStrategy: dataEncodingStrategy,
                                      dateEncodingStrategy: dateEncodingStrategy,
                                      keyEncodingStrategy: keyEncodingStrategy,
                                      nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy),
                   encoding: stringEncoding)
            .unwrappedOrThrow(error: JsonEncodingError.failedToEncodeDataToString(attemptedEncoding: stringEncoding))
    }
}



/// An error which can occur while encoding something to JSON.
///
/// Since `JSONEncoder` does not expose which type it returns for errors, this type is used for errors thrown by
/// `SerializationTools` while encoding
public enum JsonEncodingError: Error {
    
    /// Thrown when something successfully encoded a value to JSON-formatted `Data`, but failed to convert that `Data`
    /// to a `String` when using the given attempted string encoding
    ///
    /// - Parameter attemptedEncoding: The encoding that was used when trying to encode the `Data` to a `String`
    case failedToEncodeDataToString(attemptedEncoding: String.Encoding)
}



public extension JSONEncoder.NonConformingFloatEncodingStrategy {
    
    /// Converts these non-conforming floats to strings which are equivalent to JavaScript's representations
    static let convertToJavaScriptStyleStrings =
        convertToString(positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN")
}



// MARK: - Decoding

public extension Decodable {
    
    /// Decodes the given JSON-formatted data into a new object. The given data should be an encoded Unicode string.
    /// See also `init(jsonString:)`.
    ///
    /// - Parameters:
    ///   - jsonData:                           The JSON-formatted data to decode into a new object
    ///   - dataDecodingStrategy:               _optional_ - How `Data` values should be decoded. Defaults to `.base64`
    ///   - dateDecodingStrategy:               _optional_ - How `Date` values should be decoded. Defaults to `.iso8601`
    ///   - keyDecodingStrategy:                _optional_ - How JSON keys should be translated to Swift field names.
    ///                                         Defaults to `.useDefaultKeys`
    ///   - nonConformingFloatEncodingStrategy: _optional_ - How numerical values should be decoded when they cannot be
    ///                                         directly represented in JSON.
    ///                                         Defaults to `.convertToJavaScriptStyleStrings`
    ///
    /// - Throws: Any error which describes why an object couldn't be decoded
    init(jsonData: Data,
         dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
         nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .convertFromJavaScriptStyleStrings)
    throws {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self = try decoder.decode(Self.self, from: jsonData)
    }
    
    
    /// Decodes the given JSON-formatted string into a new object.
    /// See also `init(jsonData:)`.
    ///
    /// - Parameters:
    ///   - jsonString:                         The JSON-formatted string to decode into a new object
    ///   - dataDecodingStrategy:               _optional_ - How `Data` values should be decoded. Defaults to `.base64`
    ///   - dateDecodingStrategy:               _optional_ - How `Date` values should be decoded. Defaults to `.iso8601`
    ///   - keyDecodingStrategy:                _optional_ - How JSON keys should be translated to Swift field names.
    ///                                         Defaults to `.useDefaultKeys`
    ///   - nonConformingFloatEncodingStrategy: _optional_ - How numerical values should be decoded when they cannot be
    ///                                         directly represented in JSON.
    ///                                         Defaults to `.convertToJavaScriptStyleStrings`
    ///   - stringEncoding:                      _optional_ - How to enocde the string to a `Data`. Defaults to `.utf8`
    ///
    /// - Throws: Any error which describes why an object couldn't be decoded. If this occurs outside `JSONDecoder`,
    ///           then this will be a `JsonDecodingError`
    init(jsonString: String,
         dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
         dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601,
         keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
         nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .convertFromJavaScriptStyleStrings,
         stringEncoding: String.Encoding = .utf8)
    throws {
        try self.init(jsonData: try jsonString.data(using: stringEncoding)
                    .unwrappedOrThrow(error: JsonDecodingError.failedToDecodeDataFromString(attemptedEncoding: stringEncoding)),
                      dataDecodingStrategy: dataDecodingStrategy,
                      dateDecodingStrategy: dateDecodingStrategy,
                      nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy)
    }
}



/// An error which can occur while decoding something from JSON.
///
/// Since `JSONDecoder` does not expose which type it returns for errors, this type is used for errors thrown by
/// `SerializationTools` while decoding
enum JsonDecodingError: Error {
    
    /// Thrown when something failed to convert a `String` to a `Data` when using the given attempted string encoding
    ///
    /// - Parameter attemptedEncoding: The encoding that was used when trying to encode the `String` to a `Data`
    case failedToDecodeDataFromString(attemptedEncoding: String.Encoding)
}



public extension JSONDecoder.NonConformingFloatDecodingStrategy {
    
    /// Converts JavaScript's representations of non-conforming floats as strings, to Swift's actual versions
    static let convertFromJavaScriptStyleStrings =
        convertFromString(positiveInfinity: "Infinity", negativeInfinity: "-Infinity", nan: "NaN")
}
