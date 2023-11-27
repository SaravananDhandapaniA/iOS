//
//  CollectionViewTableViewCell.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(cell: CollectionViewTableViewCell, viewModel: DetailModel, selectedData: Title)
}


class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    private var titles: [Title] = [Title]()
    var isAlreadyDownloaded = false
    weak var delegate:CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.collectionIdentifier)
        collectionView.backgroundColor = .black
        return collectionView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .yellow
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func downloadMoviesAt(indexPath: IndexPath) {
        checkAlreadyDownloaded(indexPath: indexPath)
        
        if !isAlreadyDownloaded {
            DataPersistenceManager.shared.downloadMovieWith(model: titles[indexPath.row]) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(Notification(name: Notification.Name("Downloaded"), object: nil))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func checkAlreadyDownloaded(indexPath: IndexPath) {
        DataPersistenceManager.shared.fetchMovieWithId(with: titles[indexPath.row].id) { result in
            switch result {
            case .success(_):
                self.isAlreadyDownloaded = true
            case .failure(_):
                self.isAlreadyDownloaded = false
            }
        }
    }
}


extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.collectionIdentifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let data = titles[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.configure(with: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let data = titles[indexPath.row]
        guard let titleName = data.original_title ?? data.original_name else {return}
        
        Network.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            switch result {
            case .success(let video):
                print("Video:\(video)")
                guard let strongSelf = self else {return}
                let selectedVideo = self?.titles[indexPath.row]
                guard let desc = selectedVideo?.overview else {return}
                let viewModel = DetailModel(title: titleName, description: desc, videoView: video)
                self?.delegate?.collectionViewTableViewCellDidTapCell(cell: strongSelf, viewModel: viewModel, selectedData: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self]_ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil , state: .off) { _ in
                self?.downloadMoviesAt(indexPath: indexPath)
            }
            return UIMenu(title: "",options: .displayInline, children: [downloadAction])
        }
        return config
    }
    
}
