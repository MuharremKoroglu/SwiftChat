//
//  ContactsTableViewCell.swift
//  SwiftChat
//
//  Created by Muharrem Köroğlu on 16.05.2024.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ContactTableViewCell"
    
    private let contactProfileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        return imageView
    }()
    
    private let contactName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15)
        label.backgroundColor = .label
        return label
    }()
    
    private let contactPhoneNumber : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10)
        label.backgroundColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell (contact : ContactInfo) {
        Task {
            let response = await SCImageDownloader.shared.downloadImage(imageUrl: URL(string: contact.picture.large)!)
            
            switch response {
            case .success(let data):
                self.contactProfileImage.image = UIImage(data: data)
            case .failure(_):
                self.contactProfileImage.image = UIImage(systemName: "gear")
            }
            
        }
        self.contactName.text = contact.name.first + " " + contact.name.last
        self.contactPhoneNumber.text = contact.phone
        
    }
    
    
    private func setUpConstraints() {
        
        addSubViews(
            contactProfileImage,
            contactName,
            contactPhoneNumber)
        
        NSLayoutConstraint.activate([
            
            contactProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contactProfileImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            contactProfileImage.heightAnchor.constraint(equalToConstant: 50),
            contactProfileImage.widthAnchor.constraint(equalToConstant: 50),
            
            contactName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contactName.leadingAnchor.constraint(equalTo: contactProfileImage.trailingAnchor, constant: 10),
            contactName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            contactPhoneNumber.topAnchor.constraint(equalTo: contactName.bottomAnchor, constant: 10),
            contactPhoneNumber.leadingAnchor.constraint(equalTo: contactProfileImage.trailingAnchor, constant: 10),
            contactPhoneNumber.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            
        ])
        
    }
    
    

}
