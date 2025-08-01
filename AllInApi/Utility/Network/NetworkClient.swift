//
//  NetworkClient.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

/// Defines the networking responsibilities for fetching and decoding data.
protocol NetworkClientProtocol {
    /// Performs a network request and decodes the response into a Codable object.
    /// - Parameters:
    ///   - request: A configured `URLRequest`.
    ///   - returnType: The expected Codable type.
    /// - Returns: A decoded object of the specified type.
    func fetchRecord<T: Codable>(url request: URLRequest, _ returnType: T.Type) async throws -> T
}

/// Concrete implementation of `NetworkClientProtocol` using `URLSession`.
struct NetworkClient: NetworkClientProtocol {
    init() {}
    
    /// Performs the API call, validates the response, and decodes the result.
    func fetchRecord<T>(url request: URLRequest, _ returnType: T.Type) async throws -> T where T: Codable {
        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Validate HTTP response status code
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            // Check for non-empty data
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            do {
                // Decode the response data into the expected type
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                // Handle decoding errors
                throw NetworkError.decodingError
            }
        } catch let error {
            // Handle session/network-level errors
            throw NetworkError.urlSessionError(error)
        }
    }
}
