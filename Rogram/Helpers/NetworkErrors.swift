//
//  Errors.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    
    case invalidURL
    case dataFetchError(URLError)
    case decodingError(DecodingError)
    case imageConversionError
    
    static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.dataFetchError(let lhsError), .dataFetchError(let rhsError)):
            return lhsError.code == rhsError.code // Compare URLError codes
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription // Compare descriptions of DecodingErrors
        case (.imageConversionError, .imageConversionError):
            return true
        default:
            return false
        }
    }
}
