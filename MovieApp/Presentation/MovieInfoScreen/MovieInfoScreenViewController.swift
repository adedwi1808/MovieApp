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
    case reviews = 2
}

class MovieInfoScreenViewController: UITableViewController {
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        setupLoadingView()
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
        
        viewModel.reviews
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] detail in
                guard let self else { return }
                tableView.reloadSections(IndexSet(integer: MovieInfoScreenSection.reviews.rawValue), with: .automatic)
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .subscribe { [weak self] errorMessage in
                guard let self = self else { return }
                showErrorMessage(errorMessage)
            }
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    loadingView.startAnimating()
                } else {
                    loadingView.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func updateNavigationBar() {
        navigationItem.title = viewModel.detail.value?.title ?? ""
    }
    
    private func showErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Something Went Wrong", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension MovieInfoScreenViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return MovieInfoScreenSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case MovieInfoScreenSection.reviews.rawValue:
            return viewModel.reviews.value.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case MovieInfoScreenSection.youtubePlayer.rawValue:
            let cell = YoutubePlayerTableViewCell()
            cell.configure(data: viewModel.trailer.value)
            return cell
        case MovieInfoScreenSection.movieDetail.rawValue:
            let cell = MovieDetailTableViewCell()
            if let detail = viewModel.detail.value {
                cell.configure(with: detail)
            }
            return cell
        case MovieInfoScreenSection.reviews.rawValue:
            if indexPath.row == self.viewModel.reviews.value.count - 1,
               viewModel.isAbleToLoadMore {
                self.viewModel.fetchReviewsNextPage()
            }
            let cell = ReviewTableViewCell()
            let data = viewModel.reviews.value[indexPath.row]
            cell.selectionStyle = .none
            cell.configure(with: data)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case MovieInfoScreenSection.reviews.rawValue:
            return "Reviews"
        default:
            return nil
        }
    }
}
