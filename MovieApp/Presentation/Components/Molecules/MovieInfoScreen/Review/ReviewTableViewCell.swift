//
//  ReviewTableViewCell.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 21/01/25.
//

import UIKit
import Kingfisher

class ReviewTableViewCell: UITableViewCell {
    
    static let identifier = "ReviewTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .black
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let headerStack = UIStackView(arrangedSubviews: [usernameLabel, ratingLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        
        let mainStack = UIStackView(arrangedSubviews: [headerStack, contentLabel, createdAtLabel])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        
        let containerStack = UIStackView(arrangedSubviews: [avatarImageView, mainStack])
        containerStack.axis = .horizontal
        containerStack.spacing = 12
        containerStack.alignment = .top
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        contentView.addSubview(containerStack)
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with review: Review) {
        usernameLabel.text = "@\(review.authorDetails.username)"
        ratingLabel.text = "Rating: \(review.authorDetails.rating)/10"
        contentLabel.text = review.content
        createdAtLabel.text = review.createdAt
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w200\(review.authorDetails.avatarPath)") {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
            )
        }
    }
}
