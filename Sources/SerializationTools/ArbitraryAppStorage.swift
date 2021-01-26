//
//  ArbitraryAppStorage.swift
//  
//
//  Created by Ben Leggiero on 2020-12-19.
//

import SwiftUI
import Combine



@available(macOS 10.15, *)
@available(iOS 13.0, *)
@propertyWrapper
public final class ArbitraryAppStorage<WrappedValue: Codable>: ObservableObject {
    
    @Published
    public var wrappedValue: WrappedValue
    
    private var storageChangeListener: AnyCancellable?
    
    private let userDefaults: UserDefaults
    
    
    public init(wrappedValue: WrappedValue, key: String, in userDefaults: UserDefaults = .standard) {
        self.wrappedValue = wrappedValue
        self.userDefaults = userDefaults
        
        userDefaults.arbitraryStorage[key] = wrappedValue
        
        storageChangeListener = userDefaults.publisher(for: \.arbitraryStorage)
            .compactMap { $0[key] as? WrappedValue }
            .sink { value in
                self.wrappedValue = value
            }
    }
}



@available(macOS 10.15, *)
@available(iOS 13.0, *)
public extension ArbitraryAppStorage {
    
    /// Clears the arbitrary app storage
    /// 
    /// - Parameter userDefaults: _optional_ - If you're using a custom UserDefaults for this, specify it here to clear
    ///                           that one. Defaults to `.standard`
    static func clear(from userDefaults: UserDefaults = .standard) {
        userDefaults.set(nil, forKey: UserDefaults.arbitraryStorageKey)
    }
}



private extension UserDefaults {
    
    static let arbitraryStorageKey = "org.RougeWare.SerializationTools.arbitraryStorage"
    
    @objc var arbitraryStorage: [String : Any] {
        get {
            return dictionary(forKey: Self.arbitraryStorageKey) ?? [:]
        }
        set {
            set(newValue, forKey: Self.arbitraryStorageKey)
        }
    }
}
