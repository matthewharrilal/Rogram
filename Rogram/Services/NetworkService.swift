//
//  NetworkService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

protocol NetworkProtocol: AnyObject {
    func executeRequest<T>(urlString: String) async -> T? where T: Decodable
    func fetchImageForURL(_ urlString: String) async -> UIImage?
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
            return results
        }
        catch {
            print("Error decoding results")
            return nil
        }
    }
    
    func fetchImageForURL(_ urlString: String) async -> UIImage? {
        // MARK: TODO -> Throw errors here
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            return image
        }
        catch {
            print("Trouble fetching image")
            return nil
        }
    }
}
