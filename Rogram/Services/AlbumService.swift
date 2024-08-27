//
//  AlbumCollectionService.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import UIKit

protocol AlbumFetcherProtocol: AnyObject {
    /// Fetches album collections as an asynchronous stream of posts.
    /// - Returns: An `AsyncStream` of arrays of `Post` objects, where each array represents a collection of posts from an album.
    func fetchAlbumCollections() async -> AsyncStream<[Post]?>
}

class AlbumFetcherService: AlbumFetcherProtocol {
    
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    func fetchAlbumCollections() async -> AsyncStream<[Post]?> {
        AsyncStream<[Post]?> { [weak self] continuation in
            guard let self = self else { return }
            Task {
                await withTaskGroup(of: [Post]?.self) { taskGroup in
                    self.addTasksToGroup(&taskGroup)

                    for await albumCollection in taskGroup {
                        continuation.yield(albumCollection)
                    }
                    
                    continuation.finish()
                }
            }
        }
    }
}

private extension AlbumFetcherService {

    /// Adds tasks to the task group for fetching individual albums.
    /// - Parameter taskGroup: The task group to which tasks are added.
    func addTasksToGroup(_ taskGroup: inout TaskGroup<[Post]?>) {
        for counter in 1..<11 {
            taskGroup.addTask {
                await self.fetchIndividualAlbum(counter)
            }
        }
    }
    
    /// Fetches an individual album based on its index.
    /// - Parameter counter: The index of the album to fetch.
    /// - Returns: An array of `Post` objects for the album, or `nil` if there was an error.
    func fetchIndividualAlbum(_ counter: Int) async -> [Post]? {
        // MARK: TODO -> Not a fan of defining URL String directly like this
        let urlString = "https://jsonplaceholder.typicode.com/album/\(counter)/photos"
        do {
            return try await self.networkService.executeRequest(urlString: urlString)
        } catch {
            print("Error fetching album \(counter): \(error)")
            return nil
        }
    }
}
