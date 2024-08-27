//
//  PostService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

protocol PostFetcherProtocol: AnyObject {
    /// Streams aggregated posts for the given array of `Post` objects.
    /// - Parameter posts: The array of `Post` objects to be processed.
    /// - Returns: An `AsyncStream` of `AggregatedPost` objects.
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
                // Create a throwing task group to process each post concurrently
                try await withThrowingTaskGroup(of: AggregatedPost?.self) { taskGroup in
                    self.addTasksToTaskGroup(posts: posts, &taskGroup)
                    
                    // Iterate over the completed tasks and yield the results
                    for try await aggregatedPost in taskGroup {
                        if let aggregatedPost = aggregatedPost {
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
    
    /// Adds tasks to the task group for processing each post.
    /// - Parameters:
    ///   - posts: The array of `Post` objects to be processed.
    ///   - taskGroup: The task group to which tasks are added.
    func addTasksToTaskGroup(posts: [Post],  _ taskGroup: inout ThrowingTaskGroup<AggregatedPost?, Error>) {
        for post in posts {
            taskGroup.addTask {
                await self.processAggregatedPost(post: post)
            }
        }
    }
    
    /// Processes a single `Post` and returns an `AggregatedPost`.
    /// - Parameter post: The `Post` object to be processed.
    /// - Returns: An `AggregatedPost` object if successful, or `nil` if there was an error.
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
