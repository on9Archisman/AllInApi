//
//  ErrorHandler.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

/// Enum defining various types of network-related errors
enum NetworkError: Error {
    case invalidURL              // URL provided is not valid
    case invalidResponse         // Received response is not HTTP 200 or acceptable
    case noData                  // Server returned no data
    case decodingError           // Failed to decode JSON response
    case urlSessionError(Error)  // Underlying URLSession error
    case noInternet              // Device has no internet connectivity
}

// MARK: - Localized description for each error
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
            return error.localizedDescription // Surface original URLSession error
        case .noInternet:
            return "No internet connection"
        }
    }
}
