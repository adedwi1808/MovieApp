//
//  MovieInfoScreenViewController.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit
import RxSwift
import RxCocoa

enum MovieInfoScreenSection: Int, CaseIterable {
    case youtubePlayer = 0
    case movieDetail = 1
}

class MovieInfoScreenViewController: UITableViewController {
    
    let viewModel: MovieInfoScreenViewModel!
    private let disposeBag = DisposeBag()
    
    init(viewModel: MovieInfoScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(YoutubePlayerTableViewCell.self, forCellReuseIdentifier: YoutubePlayerTableViewCell.identifier)
        tableView.register(MovieDetailTableViewCell.self, forCellReuseIdentifier: MovieDetailTableViewCell.identifier)
        
        viewModel.fetchMovies()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.detail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self else { return }
                tableView.reloadData()
                updateNavigationBar()
            })
            .disposed(by: disposeBag)
        
        viewModel.trailer
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self else { return }
                tableView.reloadSections(IndexSet(integer: MovieInfoScreenSection.youtubePlayer.rawValue), with: .automatic)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateNavigationBar() {
        navigationItem.title = viewModel.detail.value?.title ?? ""
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
            cell.configure(data: viewModel.trailer.value)
            return cell
        case MovieInfoScreenSection.movieDetail.rawValue:
            guard let detail = viewModel.detail.value else { return UITableViewCell() }
            let cell = MovieDetailTableViewCell()
            cell.configure(with: detail)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
