//
//  UserListViewModel.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

// MARK: - Protocol to define the required interface for the ViewModel
protocol UserListViewModelProtocol {
    var fetchLimit: Int { get }
    var fetchOffset: Int { get }
    var totalUsers: Int { get }
    var isPaginating: Bool { get }
    
    func fetchUsers() async
}

// MARK: - ViewModel to handle user list fetching and pagination logic
class UserListViewModel: ObservableObject, UserListViewModelProtocol {
    
    // Dependency to perform network request for user list
    private let userListResource: UserListResourceProtocol
    
    // Number of items to fetch per request
    private(set) var fetchLimit = 20
    
    // Offset used for pagination
    private(set) var fetchOffset = 0
    
    // Total number of users returned by the server
    private(set) var totalUsers = 0
    
    // Flag to prevent duplicate pagination requests
    private(set) var isPaginating = false
    
    // Initialize with a resource conforming to UserListResourceProtocol
    init(userListResource: UserListResourceProtocol) {
        self.userListResource = userListResource
    }
    
    // Published array to store fetched users, observable by UI
    @Published var users: [User] = []
    
    // Published flag to indicate loading state
    @Published private(set) var isLoading: Bool = false
    
    // Published error message to be shown on UI
    @Published private(set) var errorMessage: String?
    
    // Fetch users from network using pagination
    func fetchUsers() async {
        
        // Check for internet connectivity before making request
        guard NetworkMonitor.shared.isConnected else {
            errorMessage = NetworkError.noInternet.errorDescription
            return
        }
        
        // Avoid unnecessary API calls if all users are already fetched
        guard users.count < totalUsers || totalUsers == 0 else {
            return
        }
        
        // Prevent multiple simultaneous requests
        guard !isPaginating else { return }
        
        isPaginating = true
        isLoading = true
        
        do {
            // Make API call and decode response
            let result = try await userListResource.getUserList(limit: fetchLimit, offset: fetchOffset)
            
            // Append new users to existing list
            users.append(contentsOf: result.users ?? [])
            
            // Update total and offset for next request
            totalUsers = result.total ?? 0
            fetchOffset += fetchLimit
            
            // Reset flags
            isPaginating = false
            isLoading = false
            
        } catch let error as NetworkError {
            // Handle known network errors
            errorMessage = error.errorDescription
            isPaginating = false
            isLoading = false
        } catch {
            // Handle unexpected errors
            errorMessage = error.localizedDescription
            isPaginating = false
            isLoading = false
        }
    }
}
