//
//  MovieInfoScreenViewController.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit

enum MovieInfoScreenSection: Int, CaseIterable {
    case youtubePlayer = 0
    case movieDetail = 1
}

class MovieInfoScreenViewController: UITableViewController {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}

extension MovieInfoScreenViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MovieInfoScreenSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case MovieInfoScreenSection.youtubePlayer.rawValue:
            let cell = YoutubePlayerTableViewCell()
            return cell
        default:
            return UITableViewCell()
        }
    }
}
