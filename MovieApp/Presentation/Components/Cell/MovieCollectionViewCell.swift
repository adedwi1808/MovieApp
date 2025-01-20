//
//  MovieCollectionViewCell.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "MoviewCell"
    
    private var posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private var urlSessionTask: URLSessionDataTask? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(posterView)
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = nil
        posterView.kf.cancelDownloadTask()
    }
    
    func configure(data movie: Movie) {
        guard let path = movie.posterPath,
              let url = URL(string: "https://image.tmdb.org/t/p/w500\(path)") else {
            return
        }
        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]
        
        posterView.kf.setImage(with: url, options: options)
    }
    
}
