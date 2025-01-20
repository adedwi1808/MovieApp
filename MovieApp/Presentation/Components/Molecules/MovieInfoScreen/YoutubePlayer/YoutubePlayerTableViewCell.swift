//
//  YoutubePlayerTableViewCell.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit
import YouTubeiOSPlayerHelper

class YoutubePlayerTableViewCell: UITableViewCell {
    static let identifier = "YoutubePlayerTableViewCell"
    private let youtubePlayer = YTPlayerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(youtubePlayer)
        youtubePlayer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            youtubePlayer.topAnchor.constraint(equalTo: contentView.topAnchor),
            youtubePlayer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            youtubePlayer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            youtubePlayer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            youtubePlayer.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configure(data: MovieVideos?) {
        guard let key = data?.key else { return }
        youtubePlayer.load(withVideoId: key)
    }
}
