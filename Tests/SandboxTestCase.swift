//
//  SandboxTestCase.swift
//  GitIdentity
//
//  Created by Paul Calnan on 6/2/19.
//  Copyright (C) 2018-2019 Anodized Software, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

import GitIdentityCore
import XCTest

class SandboxTestCase: XCTestCase {

    private(set) var fs: Sandbox!

    override func setUp() {
        super.setUp()

        do {
            fs = try Sandbox.testContents()
        }
        catch {
            fatalError("Error creating sandbox: \(error)")
        }
    }

    override func tearDown() {
        do {
            try fs.destroy()
        }
        catch {
            fatalError("Error destroying sandbox: \(error)")
        }
        super.tearDown()
    }

    var rootPath: String {
        return fs.root.path
    }

    var sshPath: String {
        return fs.path(".ssh")
    }

    func createTestConfig() throws -> Configuration {
        let config = try Configuration.load(file: File(path: fs.path(".git-identity-config.json")))
        return config
    }

    func verify<Success>(_ result: Result<Success, Error>?, _ expected: Success, file: StaticString = #file, line: UInt = #line) where Success: Equatable {

        guard let result = result else {
            XCTFail("Result is nil", file: file, line: line)
            return
        }

        switch result {
        case .success(let actual):
            XCTAssertEqual(expected, actual, file: file, line: line)

        case .failure(let error):
            XCTFail("Unexpected error: \(error)", file: file, line: line)
        }
    }
}
