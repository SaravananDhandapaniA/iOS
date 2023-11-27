//
//  DownloadsViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    var dowloadedMovies:[DownloadMovies] = [DownloadMovies]()
    var DownloadTable = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        setuptableView()
        view.addSubview(DownloadTable)
        fetchDownloadedMoviesInCoreData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDownloadedMoviesInCoreData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DownloadTable.frame = view.bounds
    }

    
    func setuptableView() {
        DownloadTable = UITableView(frame: .zero, style: .grouped)
        DownloadTable.register(UINib(nibName: "UpcomingTableViewCell", bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.upComingIdentifier)
        DownloadTable.backgroundColor = .black
        DownloadTable.delegate = self
        DownloadTable.dataSource = self
    }

}

extension DownloadsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dowloadedMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.upComingIdentifier, for: indexPath) as? UpcomingTableViewCell else {return UITableViewCell()}
        let posterURL = dowloadedMovies[indexPath.row].poster_path ?? "Unkonw"
        let titleName = dowloadedMovies[indexPath.row].original_title ?? dowloadedMovies[indexPath.row].original_name ?? "Unlnown"
        cell.configure(with: TitleModel(posterURL: posterURL, titleName: titleName))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataPersistenceManager.shared.deleteMovieWith(model: dowloadedMovies[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Deleted the item sucessfully")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self.dowloadedMovies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
}

extension DownloadsViewController {
    
    func fetchDownloadedMoviesInCoreData() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let data):
                self?.dowloadedMovies = data
                DispatchQueue.main.async {
                    self?.DownloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func navbarSetup() {
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .black
    }
}
