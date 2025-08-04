//
//  UserListViewModel.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

protocol UserListViewModelProtocol {
    var fetchLimit: Int { get }
    var fetchOffset: Int { get }
    var totalUsers: Int { get }
    var isPaginating: Bool { get }
    
    func fetchUsers() async
}

class UserListViewModel: ObservableObject, UserListViewModelProtocol {
    private let userListResource: UserListResourceProtocol
    private let networkStatusProvider: NetworkStatusProvider
    
    private(set) var fetchLimit = 20
    private(set) var fetchOffset = 0
    private(set) var totalUsers = 0
    private(set) var isPaginating = false
    
    init(
        userListResource: UserListResourceProtocol,
        networkStatusProvider: NetworkStatusProvider
    ) {
        self.userListResource = userListResource
        self.networkStatusProvider = networkStatusProvider
    }
    
    @Published var users: [User] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    func fetchUsers() async {
        guard networkStatusProvider.isConnected else {
            errorMessage = NetworkError.noInternet.errorDescription
            return
        }
        
        guard users.count < totalUsers || totalUsers == 0 else {
            return
        }
        
        guard !isPaginating else { return }
        isPaginating = true
        isLoading = true
        
        do {
            let result = try await userListResource.getUserList(limit: fetchLimit, offset: fetchOffset)
            users.append(contentsOf: result.users ?? [])
            totalUsers = result.total ?? 0
            fetchOffset += fetchLimit
            isPaginating = false
            isLoading = false
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
            isPaginating = false
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isPaginating = false
            isLoading = false
        }
    }
}
