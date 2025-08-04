//
//  UserListDTOTests.swift
//  AllInApiTests
//
//  Created by Archisman on 04/08/25.
//

import XCTest
@testable import AllInApi

final class UserListDTOTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_UserDecodingFromJSON() throws {
        /// Mock JSON
        let jsonData = """
    {
      "users": [
        {
          "id": 1,
          "firstName": "Emily",
          "lastName": "Johnson",
          "email": "emily.johnson@x.dummyjson.com",
          "image": "https://dummyjson.com/icon/emilys/128"
        },
        {
          "id": 2,
          "firstName": "Michael",
          "lastName": "Williams",
          "email": "michael.williams@x.dummyjson.com",
          "image": "https://dummyjson.com/icon/michaelw/128",
        }
      ],
      "total": 208,
      "skip": 0,
      "limit": 2
    }
    """.data(using: .utf8)!
        
        let decodedResult = try JSONDecoder().decode(UserListDTO.self, from: jsonData)
        
        XCTAssert(!jsonData.isEmpty, "It should have some value in it")
        XCTAssert(decodedResult.limit ?? 0 > 0, "It should have some value")
        XCTAssertEqual(decodedResult.limit, 2, "It should have limit 2 here")
        XCTAssertNotNil(decodedResult.users, "It contains users")
        XCTAssertEqual(decodedResult.users?.first?.firstName, "Emily")
    }
    
    func test_UserEncodingToJSON() throws {
        /// Mock Users Data
        let userListDTO: UserListDTO = .init(
            users: [
            .init(id: 1, firstName: "Emily", lastName: "Johnson", email: "emily.johnson@x.dummyjson.com", image: "https://dummyjson.com/icon/emilys/128"),
            User(id: 2, firstName: "Archisman", lastName: "Banerjee", email: "archisman.tech@gmail.com", image: "https://dummyjson.com/icon/emilys/128")
            ],
            total: 2,
            skip: 0,
            limit: 208,
            message: ""
        )
        
        let encodedData = try JSONEncoder().encode(userListDTO)
        let jsonString = String(data: encodedData, encoding: .utf8)!
        
        XCTAssertEqual(userListDTO.users?[1].lastName, "Banerjee")
        XCTAssert(!jsonString.isEmpty, "It should not be empty")
        XCTAssert(jsonString.contains("\"firstName\":\"Emily\""), "It should contain first name")
        XCTAssertTrue(jsonString.contains("\"limit\":208"))
        XCTAssertTrue(jsonString.contains("Archisman"))
    }
    
    func test_UserEncodingAndDecodingToJSON() throws {
        /// Mock Users Data
        let userListDTO: UserListDTO = .init(
            users: [
            .init(id: 1, firstName: "Emily", lastName: "Johnson", email: "emily.johnson@x.dummyjson.com", image: "https://dummyjson.com/icon/emilys/128"),
            User(id: 2, firstName: "Archisman", lastName: "Banerjee", email: "archisman.tech@gmail.com", image: "https://dummyjson.com/icon/emilys/128")
            ],
            total: 2,
            skip: 0,
            limit: 208,
            message: ""
        )
        
        let encodedData = try JSONEncoder().encode(userListDTO)
        let decodedData = try JSONDecoder().decode(UserListDTO.self, from: encodedData)
        
        XCTAssertEqual(userListDTO, decodedData)
        XCTAssertEqual(decodedData.users?[1].lastName, "Banerjee")
        XCTAssert(decodedData.limit ?? 0 > 0, "It should have some value")
        XCTAssertNotNil(decodedData.users, "It contains users")
    }
}
