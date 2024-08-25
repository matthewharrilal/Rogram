//
//  NetworkService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation

protocol NetworkProtocol: AnyObject {
    func executeRequest<T>(urlString: String) async -> T? where T: Decodable
}

class NetworkServiceImplementation: NetworkProtocol {
    
    func executeRequest<T>(urlString: String) async -> T? where T : Decodable {
        // MARK: TODO -> Throw specific errors here
        guard let url = URL(string: urlString) else {
            print("Error creating URL Request from URL")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(T.self, from: data)
            print(results)
            return results
        }
        catch {
            print("Error decoding results")
            return nil
        }
    }
}
