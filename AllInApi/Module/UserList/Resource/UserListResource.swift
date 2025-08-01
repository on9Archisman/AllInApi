//
//  UserListResource.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

protocol UserListResourceProtocol {
    func getUserList(limit: Int, offset: Int) async throws -> UserListDTO
}

struct UserListResource: UserListResourceProtocol {
    private let networkClient: NetworkClientProtocol
    
    public init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getUserList(limit: Int, offset: Int) async throws -> UserListDTO {
        guard var components = URLComponents(string: Constant.userListUrl) else {
            throw NetworkError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "skip", value: "\(offset)"),
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        debugPrint("URL: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let response = try await networkClient.fetchRecord(url: request, UserListDTO.self)
            debugPrint(response)
            return response
        } catch let error as NetworkError {
            throw error
        }
    }
}
