//
//  PostService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

protocol PostFetcherProtocol: AnyObject {
    func fetchPostObjects() async -> [Post]?
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
}
