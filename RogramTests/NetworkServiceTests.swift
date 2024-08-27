//
//  NetworkServiceTests.swift
//  RogramTests
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import XCTest
@testable import Rogram

class NetworkServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testExecuteRequestSuccess() async throws {
        let expectedPosts: [Post] = [Post(id: 1, albumId: 1, title: "Test Post", url: "", thumbnailUrl: "")]
        mockNetworkService.executeRequestResult = expectedPosts
        
        let result: [Post]? = try await mockNetworkService.executeRequest(urlString: "")
        XCTAssertEqual(result?.first?.title, "Test Post")
    }
    
    func testExecuteRequestFailure() async {
        mockNetworkService.executeRequestError = NetworkError.dataFetchError(URLError(.badURL))
        
        do {
            let _: [Post]? = try await mockNetworkService.executeRequest(urlString: "https://example.com")
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.dataFetchError(URLError(.badURL)))
        }
    }
    
    func testFetchImageForURLSuccess() async throws {
        let expectedImage = UIImage()
        mockNetworkService.fetchImageResult = expectedImage
        
        let result = try await mockNetworkService.fetchImageForURL("https://example.com/image.png")
        XCTAssertNotNil(result)
    }
    
    func testFetchImageForURLFailure() async {
        mockNetworkService.fetchImageError = NetworkError.dataFetchError(URLError(.badURL))
        
        do {
            let _ = try await mockNetworkService.fetchImageForURL("https://example.com/image.png")
            XCTFail("Expected error not thrown")
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.dataFetchError(URLError(.badURL)))
        }
    }
}
