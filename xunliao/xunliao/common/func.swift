//
//  func.swift
//  xunliao
//
//  Created by Zhuanz密码0000 on 2024/10/25.
//

import Foundation
import CommonCrypto

class CommonFun {
    static func md5(_ input: String) -> String {
        let inputData = input.data(using: .utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = inputData.withUnsafeBytes { inputBytes in
            _ = CC_MD5(inputBytes, CC_LONG(inputData.count), &digest)
        }
          
        // Convert the byte array to a hexadecimal string
        let hexString = digest.map { String(format: "%02x", $0) }.joined()
        return hexString
    }
    
    static func parseJSONData(_ data: Data?) -> [String: Any]? {
        guard let validData = data else {
            return nil
        }
          
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: validData, options: []) as? [String: Any] {
                return jsonObject
            }
        } catch {
            print("Failed to parse JSON: \(error.localizedDescription)")
        }
          
        return nil
    }
}
