//
//  MovieDetailTableViewCell.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit
import Kingfisher

class MovieDetailTableViewCell: UITableViewCell {
    
    static let identifier: String = "MovieDetailTableViewCell"
    
    private var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private var yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private var durationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        return label
    }()
    
    private var voteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(yearLabel)
        contentView.addSubview(genreLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(voteLabel)
        contentView.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 12
        
        posterView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            posterView.widthAnchor.constraint(equalToConstant: 120),
            posterView.heightAnchor.constraint(equalToConstant: 180),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            yearLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: padding),
            yearLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            genreLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 4),
            genreLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: padding),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            durationLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: padding),
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            voteLabel.topAnchor.constraint(equalTo: durationLabel.bottomAnchor, constant: 4),
            voteLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: padding),
            voteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            voteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }
    
    func configure(with movie: MovieDetail) {
        titleLabel.text = movie.title
        yearLabel.text = movie.yearOfRelease
        genreLabel.text = movie.genre
        durationLabel.text = movie.durations
        voteLabel.text = movie.voteAverage
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
            posterView.kf.setImage(with: url)
        }
    }
}
