//
//  ptrauth.swift
//  SwiftUtils
//
//  Created by Linus Henze on 2021-10-01.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//  

import Foundation

#if arch(arm64)

// Missing quite a few things I need...

public func stripPtr(_ ptr: OpaquePointer) -> OpaquePointer {
    return OpaquePointer(bitPattern: UInt(bitPattern: ptr) & 0x7FFFFFFFFF)!
}

#endif
