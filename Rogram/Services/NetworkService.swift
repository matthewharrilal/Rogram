//
//  NetworkService.swift
//  Rogram
//
//  Created by Space Wizard on 8/25/24.
//

import Foundation
import UIKit

protocol NetworkProtocol: AnyObject {
    func executeRequest<T>(urlString: String) async throws -> T? where T: Decodable
    func fetchImageForURL(_ urlString: String) async throws -> UIImage?
}

class NetworkServiceImplementation: NetworkProtocol {
    
    func executeRequest<T>(urlString: String) async throws -> T? where T : Decodable {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let results = try JSONDecoder().decode(T.self, from: data)
            return results
        }
        catch let dataError as URLError {
            throw NetworkError.dataFetchError(dataError)
        }
        catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        }
        catch {
            throw error
        }
    }
    
    func fetchImageForURL(_ urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else { throw NetworkError.invalidURL }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            return image
        }
        catch let dataError as URLError {
            throw NetworkError.dataFetchError(dataError)
        }
        catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        }
        catch {
            throw error
        }
    }
}
