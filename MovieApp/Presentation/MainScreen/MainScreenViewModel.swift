//
//  MainScreenViewModel.swift
//  MovieApp
//
//  Created by Ade Dwi Prayitno on 20/01/25.
//

import RxSwift
import RxCocoa

class MovieViewModel {
    let movies = BehaviorRelay<[Movie]>(value: [Movie(id: 912649, posterPath: "/aosm8NMQ3UyoBVpSxyimorCQykC.jpg"),Movie(id: 539972, posterPath: "/i47IUSsN126K11JUzqQIOi1Mg1M.jpg"), Movie(id: 939243, posterPath: "/d8Ryb8AunYAuycVKDp5HpdWPKgC.jpg")])
    
}
