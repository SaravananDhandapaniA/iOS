//
//  ViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 13/04/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userData: [Register] = []
    let fetchRequest = NSFetchRequest<Register>(entityName: "Register")

    override func viewDidLoad() {
        super.viewDidLoad()
//        deleteData()
        fetchDataFromDB()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Registered"), object: nil, queue: nil) { _ in
            self.fetchDataFromDB()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            print("Please fill email and password")
            return
        }

        if email.isEmpty || password.isEmpty {
            print("Please fill both email & password for login")
            return
        }
        
        if let user = userData.first(where: { $0.email == email && $0.password == password }) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let mainTabBarController = MainTabBarViewController(userData: user)
                sceneDelegate.window?.rootViewController = mainTabBarController
            }
        }
        
        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let sceneDelegate = windowScene.delegate as? SceneDelegate {
//            sceneDelegate.window?.rootViewController = MainTabBarViewController()
//        }
        
    }
    

    @IBAction func signupButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchDataFromDB() {
        DataPersistenceManager.shared.fetchUserSignupData { [weak self]result in
            switch result {
            case .success(let data):
                self?.userData = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteData() {
        do {
            let objects = try context.fetch(fetchRequest)
            _ = objects.map({context.delete($0)})
            try context.save()
            print("Deleted succses")
        } catch {
            print("Deleting error:\(error)")
        }
    }
}

