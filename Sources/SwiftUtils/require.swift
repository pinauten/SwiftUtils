//
//  require.swift
//  SwiftUtils
//
//  Created by Linus Henze on 2021-10-01.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//  

import Foundation

func require(_ condition: Bool, function: String = #function, file: String = #file, line: Int = #line) {
    if !condition {
        fail("Assertion failure!", function: function, file: file, line: line)
    }
}

func fail(_ message: String = "<No description provided>", function: String = #function, file: String = #file, line: Int = #line) -> Never {
    let debugInfos = "\n\nDebugging information:\nFunction: \(function)\nFile: \(file)\nLine: \(line)"
    
    print("\nFatal Error: " + message + debugInfos)
    exit(-SIGILL)
}
