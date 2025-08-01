//
//  UserListResource.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

// MARK: - Protocol to abstract user list fetching logic
protocol UserListResourceProtocol {
    func getUserList(limit: Int, offset: Int) async throws -> UserListDTO
}

// MARK: - Concrete implementation of the protocol
struct UserListResource: UserListResourceProtocol {
    private let networkClient: NetworkClientProtocol  // Dependency injected network client
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getUserList(limit: Int, offset: Int) async throws -> UserListDTO {
        // Construct base URL
        guard var components = URLComponents(string: Constant.userListUrl) else {
            throw NetworkError.invalidURL
        }
        
        // Add query parameters for pagination
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(offset)")
        ]
        
        // Ensure the final URL is valid
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        debugPrint("URL: \(url)") // For debugging the final request URL
        
        // Create and configure the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            // Make the network call using the provided client
            let response = try await networkClient.fetchRecord(url: request, UserListDTO.self)
            debugPrint(response) // Log the response for debugging
            return response
        } catch let error as NetworkError {
            // Handle known network errors
            throw error
        }
    }
}
