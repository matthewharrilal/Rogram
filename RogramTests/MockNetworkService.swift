//
//  MockNetworkService.swift
//  RogramTests
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import XCTest
@testable import Rogram

class MockNetworkService: NetworkProtocol {
    var executeRequestResult: Any?
    var executeRequestError: Error?
    
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable {
        if let error = executeRequestError {
            throw error
        }
        return executeRequestResult as? T
    }
    
    var fetchImageResult: UIImage?
    var fetchImageError: Error?
    
    func fetchImageForURL(_ urlString: String) async throws -> UIImage? {
        if let error = fetchImageError {
            throw error
        }
        return fetchImageResult
    }
}
