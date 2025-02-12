//
//  MainScreenViewController.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import UIKit
import RxSwift
import RxCocoa

class MainScreenViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    private let disposeBag = DisposeBag()
    private let viewModel: MainScreenViewModel!
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupLoadingView()
        bindViewModel()
        viewModel.fetchMovies()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func showErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "Something Went Wrong", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.movies
            .bind(to: collectionView.rx.items(cellIdentifier: MovieCollectionViewCell.identifier, cellType: MovieCollectionViewCell.self)) { _, data, cell in
                cell.configure(data: data)
            }
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
        
        collectionView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let self = self else { return }
                if indexPath.row == self.viewModel.movies.value.count - 1,
                   viewModel.isAbleToLoadMore {
                    self.viewModel.fetchMoviesNextPage()
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(Movie.self)
            .subscribe(onNext: { [weak self] movie in
                self?.handleMovieSelection(movie)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleMovieSelection(_ movie: Movie) {
        let services = MovieInfoScreenServices()
        let viewModel = MovieInfoScreenViewModel(id: movie.id, services: services)
        let vc = MovieInfoScreenViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
