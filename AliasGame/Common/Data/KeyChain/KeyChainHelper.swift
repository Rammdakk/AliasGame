//
//  KeyChainHelper.swift
//  AliasGame
//
//  Created by Рамиль Зиганшин on 14.05.2023.
//

import Foundation

final class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as [CFString : Any] as CFDictionary
        var status = SecItemAdd(query, nil)
        if status == errSecDuplicateItem || status == -25299 {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            status = SecItemUpdate(query, attributesToUpdate)
        }
        
        if status != errSecSuccess || status != 0 {
            print("Error: \(status)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete(service: String, account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func save<T>(_ item: T, service: String, account: String) throws where T: Codable {
        let data = try JSONEncoder().encode(item)
        save(data, service: service, account: account)
    }
    
    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable {
        
        guard let data = read(service: service, account: account) else {
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}

