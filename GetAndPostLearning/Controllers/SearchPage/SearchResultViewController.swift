//
//  SearchResultViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 19/06/23.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultsCollectionViewDidTapItem(ViewModel: DetailModel , selectedData: Title)
}

class SearchResultViewController: UIViewController {
    
    var movieData: [Title] = [Title]()
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.collectionIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    


}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.collectionIdentifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let data = movieData[indexPath.row].poster_path ?? ""
        cell.configure(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedItem = movieData[indexPath.row]
        let titleName = selectedItem.original_title ?? selectedItem.original_name ?? ""
        let desc = selectedItem.overview ?? ""
//        let posterImage = selectedItem.poster_path ?? ""
        
        Network.shared.getMovie(with: titleName) { result in
            switch result {
            case .success(let selectedVideo):
                self.delegate?.searchResultsCollectionViewDidTapItem(ViewModel: DetailModel(title: titleName, description: desc, videoView: selectedVideo), selectedData: selectedItem)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
       
    }
    
}
