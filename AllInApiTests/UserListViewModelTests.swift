//
//  UserListViewModelTests.swift
//  AllInApiTests
//
//  Created by Archisman on 05/08/25.
//

import XCTest
@testable import AllInApi

// MARK: - Mocks

struct MockNetworkClientSuccess: NetworkClientProtocol {
    func fetchRecord<T>(url request: URLRequest, _ returnType: T.Type) async throws -> T where T : Decodable, T : Encodable {
        let mockUser = User(id: 1, firstName: "John", lastName: "Doe", email: "john@example.com", image: "")
        let dto = UserListDTO(users: [mockUser], total: 1, skip: 0, limit: 20, message: nil)
        return dto as! T
    }
}

struct MockNetworkClientFailure: NetworkClientProtocol {
    func fetchRecord<T>(url request: URLRequest, _ returnType: T.Type) async throws -> T where T : Decodable, T : Encodable {
        throw NetworkError.noData
    }
}

class MockNetworkMonitor: NetworkStatusProvider {
    var isConnected: Bool = true
}

struct MockUserListResource: UserListResourceProtocol {
    let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getUserList(limit: Int, offset: Int) async throws -> UserListDTO {
        return try await networkClient.fetchRecord(url: URLRequest(url: URL(string: "https://dummy.com")!), UserListDTO.self)
    }
}

// MARK: - Tests

final class UserListViewModelTests: XCTestCase {
    
    func test_fetchUsers_Success() async {
        // Given
        let viewModel = UserListViewModel(
            userListResource: MockUserListResource(networkClient: MockNetworkClientSuccess()),
            networkStatusProvider: MockNetworkMonitor.init()
        )
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.firstName, "John")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_fetchUsers_Failure() async {
        // Given
        let viewModel = UserListViewModel(
            userListResource: MockUserListResource(networkClient: MockNetworkClientFailure()),
            networkStatusProvider: MockNetworkMonitor.init()
        )
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, NetworkError.noData.errorDescription)
    }
    
    func test_fetchUsers_NoInternet() async {
        // Given
        let mockMonitor = MockNetworkMonitor()
        mockMonitor.isConnected = false
        
        let viewModel = UserListViewModel(
            userListResource: MockUserListResource(networkClient: MockNetworkClientSuccess()),
            networkStatusProvider: mockMonitor
        )
        
        // When
        await viewModel.fetchUsers()
        
        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, NetworkError.noInternet.errorDescription)
    }
}

