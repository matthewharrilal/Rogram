//
//  Errors.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case dataFetchError(URLError)
    case decodingError(DecodingError)
    case imageConversionError
}
