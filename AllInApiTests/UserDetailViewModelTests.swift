//
//  UserDetailViewModelTests.swift
//  AllInApiTests
//
//  Created by Archisman on 04/08/25.
//

import XCTest
@testable import AllInApi

final class UserDetailViewModelTests: XCTestCase {
    
    var sutVM: UserDetailsViewModel?
    var userObject: User = .init(id: nil, firstName: nil, lastName: nil, email: nil, image: nil)
    
    override func setUpWithError() throws {
        sutVM = UserDetailsViewModel(userDetails: userObject)
    }
    
    override func tearDownWithError() throws {
        sutVM = nil
    }
    
    func test_ViewModelWithEmptyValue() {
        
        guard sutVM != nil else {
            XCTFail("VM is nil")
            return
        }
        
        XCTAssertNil(sutVM?.userDetails?.firstName)
        XCTAssertNil(sutVM?.userDetails?.email)
        XCTAssertNil(sutVM?.userDetails?.image)
    }
    
    func test_UserDetailViewModelInitialization() {
        // Given
        let mockUser = User(
            id: 1,
            firstName: "Jane",
            lastName: "Doe",
            email: "jane.doe@example.com",
            image: "https://example.com/jane.jpg"
        )
        
        // When
        let vm = UserDetailsViewModel(userDetails: mockUser)
        
        // Then
        XCTAssertEqual(vm.userDetails?.firstName, "Jane")
        XCTAssertEqual(vm.userDetails?.email, "jane.doe@example.com")
        XCTAssertEqual(vm.userDetails?.image, "https://example.com/jane.jpg")
    }
    
    func test_UserDetailViewModelWithIncorrectValue() {
        // Given
        let mockUser = User(
            id: 1,
            firstName: "Jane",
            lastName: "Doe",
            email: "jane.doe@example.com",
            image: "https://example.com/jane.jpg"
        )
        
        // When
        let vm = UserDetailsViewModel(userDetails: mockUser)
        
        // Then
        XCTAssertNotEqual(vm.userDetails?.firstName, "Archisman")
        XCTAssertNotEqual(vm.userDetails?.email, "jane.doeexample.com")
        XCTAssertNotEqual(vm.userDetails?.image, "https://example.com/jane")
    }
    
    func test_InitWithMissingLastName() {
        let user = User(id: 1, firstName: "Jane", lastName: "", email: "jane@example.com", image: "")
        
        sutVM?.userDetails = user
        
        XCTAssertEqual(sutVM?.userDetails?.lastName?.count, 0)
        XCTAssertEqual(sutVM?.userDetails?.image, "")
    }
}
