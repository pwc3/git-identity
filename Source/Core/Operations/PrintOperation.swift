//
//  PrintOperation.swift
//  GitIdentityCore
//
//  Created by Paul Calnan on 6/1/19.
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

import Foundation

/// Operation to print information about the current identity. The result value contains the current identity name, the contents of the gitconfig file and the contents of the public key file.
public class PrintOperation: GitIdentityOperation<PrintOperation.Result> {

    /// Operation result object.
    public struct Result: Equatable {

        /// The name of the current identity.
        public var current: String

        /// The contents of the current identity's gitconfig file.
        public var gitconfig: String

        /// The contents of the current identity's public key file.
        public var publicKey: String

        public init(current: String, gitconfig: String, publicKey: String) {
            self.current = current
            self.gitconfig = gitconfig
            self.publicKey = publicKey
        }
    }

    override func execute() throws -> Result {
        let current = try config.loadCurrentIdentity()

        let gitconfig = try current.destination.gitconfig.readString().trimmingCharacters(in: .newlines)
        let publicKey = try current.destination.publicKey.readString().trimmingCharacters(in: .newlines)

        return Result(current: current.name, gitconfig: gitconfig, publicKey: publicKey)
    }

    override func printSuccess(_ value: Result) {
        let lines = [
            "Current Git identity: \(value.current)",
            "",
            "Git config contents:",
            "--------------------",
            value.gitconfig,
            "",
            "Public key:",
            "-----------",
            value.publicKey,
        ]
        print(lines.joined(separator: "\n"))
    }
}
