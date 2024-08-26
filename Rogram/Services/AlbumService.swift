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
    
    // MARK: TODO -> Clean up this method
    func fetchAlbumCollections() async -> AsyncStream<[Post]?> {
        AsyncStream<[Post]?> { [weak self] continuation in
            guard let self = self else { return }
            Task {
                await withTaskGroup(of: [Post]?.self) { taskGroup in
                    for counter in 0..<10 {
                        taskGroup.addTask {
                            let urlString = "https://jsonplaceholder.typicode.com/album/\(counter)/photos"
                            print(urlString)
                            return await self.networkService.executeRequest(urlString: urlString)
                        }
                    }
                    
                    for await albumCollection in taskGroup {
                        continuation.yield(albumCollection)
                    }
                    
                    continuation.finish()
                }
            }
        }
    }
}
