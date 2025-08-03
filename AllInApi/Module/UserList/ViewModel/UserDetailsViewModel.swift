//
//  UserDetailsViewModel.swift
//  AllInApi
//
//  Created by Archisman on 02/08/25.
//

import Foundation

class UserDetailsViewModel {
    @Published var userDetails: User?
    
    init(userDetails: User?) {
        self.userDetails = userDetails
    }
}
