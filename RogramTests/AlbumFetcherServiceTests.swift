//
//  AlbumFetcherServiceTests.swift
//  RogramTests
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import XCTest
@testable import Rogram

class AlbumFetcherServiceTests: XCTestCase {
    var mockNetworkService: MockNetworkService!
    var albumFetcherService: AlbumFetcherService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        albumFetcherService = AlbumFetcherService(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        albumFetcherService = nil
        super.tearDown()
    }
    
    func testFetchAlbumCollectionsSuccess() async {
        // Arrange
        let expectedPosts: [Post] = [Post(id: 1, albumId: 1, title: "Test Post", url: "", thumbnailUrl: "")]
        mockNetworkService.executeRequestResult = expectedPosts
        
        // Act
        let stream = await albumFetcherService.fetchAlbumCollections()
        var albumCollections: [[Post]] = []
        for await album in stream {
            if let album = album {
                albumCollections.append(album)
            }
        }
        
        // Assert
        XCTAssertEqual(albumCollections.count, 10) // Assuming 10 albums were expected
        XCTAssertEqual(albumCollections.first?.first?.title, "Test Post")
    }
    
    func testFetchAlbumCollectionsFailure() async {
        // Arrange
        mockNetworkService.executeRequestError = NetworkError.dataFetchError(URLError(.badURL))
        
        // Act
        let stream = await albumFetcherService.fetchAlbumCollections()
        var albumCollections: [[Post]] = []
        for await album in stream {
            if let album = album {
                albumCollections.append(album)
            }
        }
        
        // Assert
        XCTAssertTrue(albumCollections.isEmpty)
    }
}
