//
//  SearchViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var discoverMovieData:[Title] = [Title]()
    var discoverTable = UITableView()

    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        let searchBar = controller.searchBar
        controller.searchBar.placeholder = "Search your movie or tv shows"
        controller.searchBar.searchBarStyle = .minimal
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        controller.hidesNavigationBarDuringPresentation = false
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setuptableView()
        self.definesPresentationContext = true
        view.addSubview(discoverTable)
        navigationController?.navigationBar.barStyle = .black
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }

    func setuptableView() {
        discoverTable = UITableView(frame: .zero, style: .grouped)
        discoverTable.register(UINib(nibName: "UpcomingTableViewCell", bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.upComingIdentifier)
        discoverTable.backgroundColor = .black
        discoverTable.delegate = self
        discoverTable.dataSource = self
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoverMovieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.upComingIdentifier, for: indexPath) as? UpcomingTableViewCell else { return UITableViewCell()}
        let posterURL = discoverMovieData[indexPath.row].poster_path ?? "Unkonw"
        let titleName = discoverMovieData[indexPath.row].original_title ?? discoverMovieData[indexPath.row].original_name ?? "Unlnown"
        cell.configure(with: TitleModel(posterURL: posterURL, titleName: titleName))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = discoverMovieData[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        Network.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let selectedVideo):
                DispatchQueue.main.async {
                    let vc = DetailViewController()
                    vc.configure(with: DetailModel(title: titleName, description: title.overview ?? "", videoView: selectedVideo), selectedData: title)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension SearchViewController {
    
    func fetchDiscoverMovies() {
        Network.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let title):
                self?.discoverMovieData = title
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let search = searchController.searchBar
        
        guard let query = search.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        resultController.delegate = self
        
        Network.shared.search(with: query) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let data):
                    resultController.movieData = data
                    resultController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

extension SearchViewController: SearchResultViewControllerDelegate {
    func searchResultsCollectionViewDidTapItem(ViewModel: DetailModel, selectedData: Title) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: ViewModel, selectedData: selectedData)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
