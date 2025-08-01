//
//  UserListTableViewCell.swift
//  AllInApi
//
//  Created by Archisman on 01/08/25.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    let lblName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let lblEmail: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(lblName)
        contentView.addSubview(lblEmail)
        
        NSLayoutConstraint.activate([
            lblName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lblName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            lblEmail.topAnchor.constraint(equalTo: lblName.bottomAnchor, constant: 8),
            lblEmail.leadingAnchor.constraint(equalTo: lblName.leadingAnchor),
            lblEmail.trailingAnchor.constraint(equalTo: lblName.trailingAnchor),
            lblEmail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(user: User) {
        lblName.text = "\((user.firstName ?? "") + " " + (user.lastName ?? ""))"
        lblEmail.text = "\(user.email ?? "")"
    }
}
