//
//  String.swift
//  SwiftUtils
//
//  Created by Linus Henze on 2021-10-01.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//  

import Foundation

public extension String {
    func decodeHex() -> Data? {
        if (count % 2) != 0 {
            return nil
        }
        
        var result = Data()
        
        var index = startIndex
        while index != endIndex {
            let x = self[index]
            index = self.index(after: index)
            
            let y = self[index]
            index = self.index(after: index)
            
            guard let byte = UInt8(String(x)+String(y), radix: 16) else {
                return nil
            }
            
            result.appendGeneric(value: byte)
        }
        
        return result
    }
}
