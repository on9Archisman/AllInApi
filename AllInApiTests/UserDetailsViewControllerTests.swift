//
//  UserDetailsViewControllerTests.swift
//  AllInApiTests
//
//  Created by Archisman on 04/08/25.
//

import XCTest
import Combine
@testable import AllInApi

final class UserDetailsViewControllerTests: XCTestCase {
    
    var sutVC: UserDetailsViewController!
    var sutVM: UserDetailsViewModel!
    var userObject: User!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        userObject = nil // optional; keeps test clean
        sutVM = UserDetailsViewModel(userDetails: userObject)
        sutVC = UserDetailsViewController()
        sutVC.viewModel = sutVM
        cancellables = []
    }
    
    override func tearDown() {
        sutVC = nil
        sutVM = nil
        userObject = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_UserDetailsViewControllerDisplaysCorrectData() {
        // Given
        userObject = User(
            id: 2,
            firstName: "Archisman",
            lastName: "Banerjee",
            email: "archisman.tech@gmail.com",
            image: "https://dummyjson.com/icon/emilys/128"
        )
        
        sutVM.userDetails = userObject
        sutVC.loadViewIfNeeded() // triggers bind
        
        let expectation = XCTestExpectation(description: "UI should update after data is bound")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.sutVC.nameLabel.text, "Archisman Banerjee")
            XCTAssertEqual(self.sutVC.emailLabel.text, "archisman.tech@gmail.com")
            // Note: Validating image view requires image mocking or injecting UIImage.
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func test_bindViewModelReflectsChanges() {
        // Given
        let testUser = User(
            id: 1,
            firstName: "John",
            lastName: "Doe",
            email: "john@example.com",
            image: "https://example.com/image.jpg"
        )
        
        sutVC.loadViewIfNeeded() // Triggers viewDidLoad and binding
        
        let expectation = XCTestExpectation(description: "View reflects userDetails update")
        
        sutVM.$userDetails
            .dropFirst()
            .sink { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    XCTAssertEqual(self.sutVC.nameLabel.text, "John Doe")
                    XCTAssertEqual(self.sutVC.emailLabel.text, "john@example.com")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        sutVM.userDetails = testUser
        
        wait(for: [expectation], timeout: 1.0)
    }
}
