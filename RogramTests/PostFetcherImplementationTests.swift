//
//  PostFetcherImplementationTests.swift
//  RogramTests
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import XCTest
@testable import Rogram

class PostFetcherImplementationTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var postFetcher: PostFetcherImplementation!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        postFetcher = PostFetcherImplementation(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        postFetcher = nil
        super.tearDown()
    }
    
    func testStreamAggregatedPostsSuccess() async {
        // Arrange
        let posts = [Post(id: 1, albumId: 1, title: "Test Post", url: "", thumbnailUrl: "")]
        let expectedImage = UIImage()
        mockNetworkService.fetchImageResult = expectedImage
        
        // Act
        let stream = await postFetcher.streamAggregatedPosts(posts: posts)
        var resultPosts: [AggregatedPost] = []
        if let stream = stream {
            for await post in stream {
                resultPosts.append(post)
            }
        }
        
        // Assert
        XCTAssertEqual(resultPosts.count, 1)
        XCTAssertEqual(resultPosts.first?.title, "Test Post")
        XCTAssertEqual(resultPosts.first?.image, expectedImage)
    }
    
    func testStreamAggregatedPostsFailure() async {
        // Arrange
        let posts = [Post(id: 1, albumId: 1, title: "Test Post", url: "", thumbnailUrl: "")]
        mockNetworkService.fetchImageError = NetworkError.dataFetchError(URLError(.badURL))
        
        // Act
        let stream = await postFetcher.streamAggregatedPosts(posts: posts)
        var resultPosts: [AggregatedPost] = []
        if let stream = stream {
            for await post in stream {
                resultPosts.append(post)
            }
        }
        
        // Assert
        XCTAssertTrue(resultPosts.isEmpty)
    }
}
