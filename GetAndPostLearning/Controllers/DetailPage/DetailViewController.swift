//
//  DetailViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 20/06/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    var viewModel = DetailPageViewModel()
    var selectedMovie: Title?
    var isDownloaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
    }


    func configure(with model: DetailModel , selectedData: Title) {
        loadViewIfNeeded()
        setNavBar()
        selectedMovie = selectedData
        viewModel.setData(data: model)
        setupDataForView()
        checkDownloadStatus()
    }
    
    func setupDataForView() {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.desc
        guard let url = viewModel.url else {return}
        webView.load(URLRequest(url: url))
    }
    
    func setNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @IBAction func downloadButtonTapped(_ sender: Any) {
        
        guard let movie = selectedMovie else {return}
        if !isDownloaded {
            DataPersistenceManager.shared.downloadMovieWith(model: movie) { [weak self] result in
                switch result {
                case .success():
                    self?.isDownloaded = true
                    NotificationCenter.default.post(Notification(name: Notification.Name("Downloaded"), object: nil))
                    self?.updateDownloadButtonState(downloaded: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}


extension DetailViewController {
    
    func checkDownloadStatus() {
        guard let selectedMovie = selectedMovie else {return}
        DataPersistenceManager.shared.fetchMovieWithId(with: selectedMovie.id) { [weak self]result in
            switch result {
            case .success( _):
                self?.isDownloaded = true
                DispatchQueue.main.async {
                    self?.updateDownloadButtonState(downloaded: true)
                }
            case .failure( _):
                self?.isDownloaded = false
                DispatchQueue.main.async {
                    self?.updateDownloadButtonState(downloaded: false)
                }
            }
        }
    }
    
    func updateDownloadButtonState(downloaded: Bool) {
        if downloaded {
            downloadButton.setTitle("Downloaded", for: .normal)
            downloadButton.setTitleColor(.white, for: .normal)
            downloadButton.backgroundColor = .green
        } else {
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.setTitleColor(.white, for: .normal)
            downloadButton.backgroundColor = .red
        }
    }
    
}
