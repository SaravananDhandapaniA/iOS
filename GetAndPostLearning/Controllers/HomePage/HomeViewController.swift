//
//  HomeViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 13/06/23.
//

import UIKit
import CoreData

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var homePageTableView: UITableView!
    @IBOutlet weak var hamburgerBgView: UIView!
    @IBOutlet weak var hambugerView: UIView!
    @IBOutlet weak var trailingConstraintForHambuger: NSLayoutConstraint!
    
    var loginUser: Register?
    var randomTrendingMovies:Title?
    var headerView: HeaderView?
    var hamburger: HamburgerViewController?
    var isHamburgerMenuShown: Bool = false
    
    let sectionTitle: [String] = ["Ternding Movies" ,"Popular","Trending TV","Upcoming Movies","Top Rated"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTableView()
        setupHeaderView()
        hamburgerBgView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func setupHeaderView() {
        headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homePageTableView.tableHeaderView = headerView
    }

    func setupTableView() {
        homePageTableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        homePageTableView.backgroundColor = .black
        homePageTableView.dataSource = self
        homePageTableView.delegate = self
    }
    
    
    @IBAction func showHamburgerMenu(_ sender: Any) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.trailingConstraintForHambuger.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            self.hamburgerBgView.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.trailingConstraintForHambuger.constant = 0
                self.view.layoutIfNeeded()
            }) { (status) in
                self.isHamburgerMenuShown = true
            }
        }
               
    }
    

    @IBAction func tappedOnHamburgerBackground(_ sender: Any) {
        hideHambuger() 
    }
    


}


extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            Network.shared.getTrendingMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            Network.shared.getTrendingTvs { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            Network.shared.getPopular { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            Network.shared.getUpcomingMovies { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            Network.shared.getTopRated { result in
                switch result {
                case .success(let title):
                    cell.configure(with: title)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        header.tintColor = .black
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.uppercased()
    }
    
    
}

extension HomeViewController {
    
    func configureHeaderView() {
        Network.shared.getTrendingMovies { result in
            switch result {
            case .success(let data):
                let randomMovie = data.randomElement()
                self.randomTrendingMovies = randomMovie
                self.headerView?.configureHeader(with: TitleModel(posterURL: randomMovie?.poster_path ?? "", titleName: randomMovie?.original_title ?? "" ))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hamburgerSegue") {
            if let controller = segue.destination as? HamburgerViewController {
                hamburger = controller
                hamburger?.delegate = self
                hamburger?.userLoginData = loginUser
            }
        }
    }

}

extension HomeViewController: CollectionViewTableViewCellDelegate, HamburgerViewControllerDelegate{
    func hideHambugerMenu() {
        hideHambuger()
    }
    
    func collectionViewTableViewCellDidTapCell(cell: CollectionViewTableViewCell, viewModel: DetailModel, selectedData: Title) {
        DispatchQueue.main.async {
            let vc = DetailViewController()
            vc.configure(with: viewModel, selectedData: selectedData)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func hideHambuger() {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.trailingConstraintForHambuger.constant = 10
            self.view.layoutIfNeeded()
        }) { (status) in
            UIView.animate(withDuration: 0.1, animations: {
                self.trailingConstraintForHambuger.constant = -280
                self.view.layoutIfNeeded()
            }) { (status) in
                self.hamburgerBgView.isHidden = true
                self.isHamburgerMenuShown = false
            }
        }
    }
    
}

extension HomeViewController {
    
    
}
