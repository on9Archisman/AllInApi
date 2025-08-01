//
//  ErrorHandler.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case urlSessionError(Error)
    case noInternet
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid HTTP response"
        case .noData:
            return "No data returned from server"
        case .decodingError:
            return "Error decoding JSON"
        case .urlSessionError(let error):
            return error.localizedDescription
        case .noInternet:
            return "No internet connection"
        }
    }
}
