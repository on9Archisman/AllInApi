//
//  NetworkClient.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

protocol NetworkClientProtocol {
    func fetchRecord<T: Codable>(url request: URLRequest, _ returnType: T.Type) async throws -> T
}

struct NetworkClient: NetworkClientProtocol {
    init() {}
    
    func fetchRecord<T>(url request: URLRequest, _ returnType: T.Type) async throws -> T where T: Codable {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw NetworkError.decodingError
            }
        } catch let error {
            throw NetworkError.urlSessionError(error)
        }
    }
}
