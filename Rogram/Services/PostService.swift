//
//  PostService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

protocol PostFetcherProtocol: AnyObject {
    func streamAggregatedPosts(posts: [Post]?) async -> AsyncStream<AggregatedPost>?
}

class PostFetcherImplementation: PostFetcherProtocol {
    
    private let networkService: NetworkProtocol
    
    init(networkService: NetworkProtocol) {
        self.networkService = networkService
    }
    
    
    func streamAggregatedPosts(posts: [Post]?) async -> AsyncStream<AggregatedPost>? {
        guard let posts = posts else { return nil }
        
        return AsyncStream<AggregatedPost> { [weak self] continuation in
            guard let self = self else { return }
            Task {
                try await withThrowingTaskGroup(of: AggregatedPost?.self) { taskGroup in
                    self.addTasksToTaskGroup(posts: posts, &taskGroup)
                    
                    for try await aggregatedPost in taskGroup {
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

private extension PostFetcherImplementation {

    func addTasksToTaskGroup(posts: [Post],  _ taskGroup: inout ThrowingTaskGroup<AggregatedPost?, Error>) {
        for post in posts {
            taskGroup.addTask {
                await self.processAggregatedPost(post: post)
            }
        }
    }
    
    func processAggregatedPost(post: Post) async -> AggregatedPost? {
        do {
            let image = try await self.networkService.fetchImageForURL(post.thumbnailUrl)
            guard let image = image else { return nil }
            let aggregatedPost = AggregatedPost(image: image, title: post.title)
            return aggregatedPost
        }
        catch {
            print("Error in task group: \(error)")
            return nil
        }
    }
}
