//
//  UIImageView+AsyncLoading.swift
//  AllInApi
//
//  Created by Archisman on 03/08/25.
//

import UIKit

extension UIImageView {
    func loadImage(
        from url: String,
        placeholderImage: UIImage? = nil
    ) {
        guard placeholderImage != nil else {
            self.image = UIImage(named: "user")
            return
        }
        
        DispatchQueue.main.async {
            self.image = placeholderImage
        }
        
        guard let url = URL(string: url) else {
            return
        }
        
        Task {
            let result = try await URLSession.shared.data(from: url)
            guard let httpResponse = result.1 as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return
            }
            
            if let image = UIImage(data: result.0) {
                Task {
                    await MainActor.run {
                        self.image = image
                    }
                }
            }
        }
    }
}
