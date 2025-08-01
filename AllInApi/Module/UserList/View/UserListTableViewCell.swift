//
//  UserListTableViewCell.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    // Label to display user's full name
    let lblName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // Label to display user's email
    let lblEmail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Custom initializer used when creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add labels to the cell's content view
        contentView.addSubview(lblName)
        contentView.addSubview(lblEmail)
        
        // Apply Auto Layout constraints
        NSLayoutConstraint.activate([
            lblName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lblName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            lblEmail.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 8),
            lblEmail.leadingAnchor.constraint(equalTo: lblName.leadingAnchor),
            lblEmail.trailingAnchor.constraint(equalTo: lblName.trailingAnchor),
            lblEmail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        // Remove selection highlight
        self.selectionStyle = .none
    }
    
    // Required initializer (not used in this setup)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Override to handle selection behavior if needed
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Cell Configuration
    
    // Method to populate the cell with user data
    func configureCell(user: User) {
        lblName.text = "\((user.firstName ?? "") + " " + (user.lastName ?? ""))"
        lblEmail.text = "\(user.email ?? "")"
    }
}
