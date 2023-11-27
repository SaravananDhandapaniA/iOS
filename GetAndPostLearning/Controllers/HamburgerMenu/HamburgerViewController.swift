//
//  HamburgerViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 29/06/23.
//

import UIKit
import CoreData


protocol HamburgerViewControllerDelegate: AnyObject{
    func hideHambugerMenu()
}

class HamburgerViewController: UIViewController {

    @IBOutlet weak var headerBgView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    weak var delegate:HamburgerViewControllerDelegate?
    var userLoginData: Register?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
    }
    
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        self.delegate?.hideHambugerMenu()
    }
    
    
}

extension HamburgerViewController {
    
    func setupUI() {
        headerBgView.layer.cornerRadius = 20
        headerBgView.clipsToBounds = true
        profileImage.makeRounded()
    }
    
    func configureData() {
        guard let data = userLoginData else {return}
        nameLabel.text = data.username
        emailLabel.text = data.email
        phoneLabel.text = String(data.phone)
    }
}
