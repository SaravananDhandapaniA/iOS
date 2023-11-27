//
//  UpComingViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 14/06/23.
//

import UIKit

class UpComingViewController: UIViewController {
    
    private var upComingMovieData:[Title] = [Title]()
    
    var upComingTable = UITableView()
        

    override func viewDidLoad() {
        super.viewDidLoad()
        navbarSetup()
        view.backgroundColor = .black
        setuptableView()
        view.addSubview(upComingTable)
        navigationController?.navigationBar.barStyle = .black
        
        fetchUpComingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upComingTable.frame = view.bounds
    }
    
    func setuptableView() {
        upComingTable = UITableView(frame: .zero, style: .grouped)
        upComingTable.register(UINib(nibName: "UpcomingTableViewCell", bundle: nil), forCellReuseIdentifier: UpcomingTableViewCell.upComingIdentifier)
        upComingTable.backgroundColor = .black
        upComingTable.delegate = self
        upComingTable.dataSource = self
    }

}


extension UpComingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upComingMovieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.upComingIdentifier, for: indexPath) as? UpcomingTableViewCell else {return UITableViewCell()}
        let posterURL = upComingMovieData[indexPath.row].poster_path ?? "Unkonw"
        let titleName = upComingMovieData[indexPath.row].original_title ?? upComingMovieData[indexPath.row].original_name ?? "Unlnown"
        cell.configure(with: TitleModel(posterURL: posterURL, titleName: titleName))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = upComingMovieData[indexPath.row]
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


extension UpComingViewController {
    
    func fetchUpComingData() {
        Network.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let title):
                self?.upComingMovieData = title
                DispatchQueue.main.async {
                    self?.upComingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func navbarSetup() {
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
