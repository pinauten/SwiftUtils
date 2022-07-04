//
//  Data.swift
//  SwiftUtils
//
//  Created by Linus Henze on 2021-10-01.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//  

import Foundation

public extension Data {
    class StringDecodingError: Error, CustomStringConvertible {
        private let _value: Data
        public var value: Data { _value }
        
        private let _encoding: String.Encoding
        public var encoding: String.Encoding { _encoding }
        
        public var description: String {
            return "Data \(value) cannot be decoded as \(encoding)"
        }
        
        public init(_ value: Data, encoding: String.Encoding) {
            _value = value
            _encoding = encoding
        }
    }
    
    /**
     * Get the raw data of an object
     *
     * - warning: This function is UNSAFE as it could leak pointers. Use with caution!
     *
     * - parameter fromObject: The object whose raw data you would like to get
     */
    init<Type: Any>(fromObject: Type) {
        var value = fromObject
        let valueSize = MemoryLayout.size(ofValue: value)
        
        self = withUnsafePointer(to: &value) { ptr in
            Data(bytes: UnsafeRawPointer(ptr).assumingMemoryBound(to: UInt8.self), count: valueSize)
        }
    }
    
    /**
     * Convert an object to raw data and append
     *
     * - warning: This function is UNSAFE as it could leak pointers. Use with caution!
     *
     * - parameter value: The value to convert and append
     */
    mutating func appendGeneric<Type: Any>(value: Type) {
        self.append(Data(fromObject: value))
    }
    
    /**
     * Convert raw data directly into an object
     *
     * - warning: This function is UNSAFE as it could be used to deserialize pointers. Use with caution!
     *
     * - parameter type: The type to convert the raw data into
     */
    func getGeneric<Object: Any>(type: Object.Type, offset: UInt = 0) -> Object {
        guard (Int(offset) + MemoryLayout<Object>.size) <= self.count else {
            fatalError("Tried to read out of bounds!")
        }
        
        return withUnsafeBytes { ptr in
            ptr.baseAddress!.advanced(by: Int(offset)).assumingMemoryBound(to: Object.self).pointee
        }
    }
    
    /**
     * Convert raw data directly into an object, if possible
     *
     * - warning: This function is UNSAFE as it could be used to deserialize pointers. Use with caution!
     *
     * - parameter type: The type to convert the raw data into
     */
    func tryGetGeneric<Object: Any>(type: Object.Type, offset: UInt = 0) -> Object? {
        guard (Int(offset) + MemoryLayout<Object>.size) <= self.count else {
            return nil
        }
        
        return withUnsafeBytes { ptr in
            ptr.baseAddress!.advanced(by: Int(offset)).assumingMemoryBound(to: Object.self).pointee
        }
    }
    
    /**
     * Bug workaround: advance crashes when passing self.count
     */
    func tryAdvance(by: Int) -> Data {
        if by >= self.count {
            return Data()
        }
        
        return self.advanced(by: by)
    }
    
    func trySubdata(in: Range<Index>) -> Data? {
        guard `in`.lowerBound >= 0 && `in`.upperBound <= self.count else {
            return nil
        }
        
        return subdata(in: `in`)
    }
    
    func toString(encoding: String.Encoding = .utf8, nullTerminated: Bool = false) throws -> String {
        if nullTerminated, let index = self.firstIndex(of: 0) {
            let new = self[..<index]
            return try new.toString(encoding: encoding)
        }
        
        guard let str = String(data: self, encoding: encoding) else {
            throw StringDecodingError(self, encoding: encoding)
        }
        
        return str
    }
}
