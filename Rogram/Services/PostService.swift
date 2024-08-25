//
//  PostService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

protocol PostFetcherProtocol: AnyObject {
    func fetchPostObjects() async -> [Post]?
    func streamAggregatedPosts(posts: [Post]?) async -> AsyncStream<AggregatedPost>?
}

class PostFetcherImplementation: PostFetcherProtocol {
    
    enum Constants {
        // MARK: TODO -> Make Album # Dynamic
        static var urlString: String = "https://jsonplaceholder.typicode.com/album/1/photos"
    }
    
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    func fetchPostObjects() async -> [Post]? {
        return await networkService.executeRequest(urlString: Constants.urlString)
    }
    
    func streamAggregatedPosts(posts: [Post]?) async -> AsyncStream<AggregatedPost>? {
        // MARK: TODO -> Throw errors
        guard let posts = posts else { return nil }
        
        return AsyncStream<AggregatedPost> { [weak self] continuation in
            guard let self = self else { return }
            Task {
                await withTaskGroup(of: AggregatedPost?.self) { taskGroup in
                    for post in posts {
                        taskGroup.addTask {
                            guard let image = await self.networkService.fetchImageForURL(post.thumbnailUrl) else { return nil }
                            
                            let aggregatedPost = AggregatedPost(image: image, title: post.title)
                            return aggregatedPost
                        }
                    }
                    
                    for await aggregatedPost in taskGroup {
                        if let aggregatedPost = aggregatedPost {
                            print(aggregatedPost.title)
                            continuation.yield(aggregatedPost)
                        }
                    }
                    
                    continuation.finish()
                }
            }
        }
    }
}
