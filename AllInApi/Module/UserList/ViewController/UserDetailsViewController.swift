//
//  UserDetailsViewController.swift
//  AllInApi
//
//  Created by Archisman on 02/08/25.
//

import UIKit
import Combine

class UserDetailsViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cancellable = Set<AnyCancellable>()
    var viewModel: UserDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "User Details"
        
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            emailLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20)
        ])
    }
    
    private func bindViewModel() {
        viewModel?.userDetails
            .publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.imageView.loadImage(from: user.image ?? "", placeholderImage: UIImage(named: "user"))
                self?.nameLabel.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
                self?.emailLabel.text = user.email
            }
            .store(in: &cancellable)
    }
}
