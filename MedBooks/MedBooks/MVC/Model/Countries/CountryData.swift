//
//  CountryData.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import Foundation

public struct CountryType: Codable {
    
    public var countryType: [String: countryInfo]
    
    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        self.countryType = [String: countryInfo]()
        for key in container.allKeys {
            let value = try container.decode(countryInfo.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.countryType[key.stringValue] = value
        }
    }
}

public struct countryInfo: Codable {
    var country: String?
    var region: String?
}

struct CountryData: Codable {
    
    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version
        case access
        case data
    }
    
    let status: String
    let statusCode: Int
    let version, access: String
    let data: CountryType
}

enum Region: Codable {
    case africa
    case antarctic
    case asia
    case centralAmerica
}
