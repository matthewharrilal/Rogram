//
//  AlbumCollectionService.swift
//  Rogram
//
//  Created by Space Wizard on 8/26/24.
//

import Foundation
import UIKit

protocol AlbumFetcherProtocol: AnyObject {
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
    func addTasksToGroup(_ taskGroup: inout TaskGroup<[Post]?>) {
        for counter in 1..<11 {
            taskGroup.addTask {
                await self.fetchIndividualAlbum(counter)
            }
        }
    }
    
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
