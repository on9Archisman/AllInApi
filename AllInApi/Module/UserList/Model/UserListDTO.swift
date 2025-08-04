//
//  UserListDTO.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import Foundation

struct UserListDTO: Codable, Equatable {
    let users: [User]?
    let total, skip, limit: Int?
    let message: String?
}

struct User: Codable, Equatable {
    let id: Int?
    let firstName, lastName, email, image: String?
}
