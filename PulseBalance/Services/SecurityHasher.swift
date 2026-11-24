//
//  SecurityHasher.swift
//  PulseBalance
//
//  Created by Ryzel Realon on 11/24/26.
//

import Foundation
import CryptoKit
import Security

enum SecurityHasher {
    static func generateSalt(length: Int = 16) -> String {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)

        if status == errSecSuccess {
            return Data(bytes).base64EncodedString()
        } else {
            return UUID().uuidString.replacingOccurrences(of: "-", with: "")
        }
    }

    static func hash(password: String, salt: String) -> String {
        let salted = "\(salt):\(password)"
        let digest = SHA256.hash(data: Data(salted.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }

    static func verify(password: String, salt: String, expectedHash: String) -> Bool {
        let candidateHash = hash(password: password, salt: salt)
        return constantTimeEquals(candidateHash, expectedHash)
    }

    private static func constantTimeEquals(_ lhs: String, _ rhs: String) -> Bool {
        let lhsBytes = Array(lhs.utf8)
        let rhsBytes = Array(rhs.utf8)
        guard lhsBytes.count == rhsBytes.count else { return false }

        var result: UInt8 = 0
        for (a, b) in zip(lhsBytes, rhsBytes) {
            result |= a ^ b
        }
        return result == 0
    }
}
