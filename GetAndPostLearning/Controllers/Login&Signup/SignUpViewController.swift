//
//  SignUpViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 08/06/23.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confrimPasswordTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userData: [Signup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confrimPassword  = confrimPasswordTextField.text else {
            showAlert(title: "Empty Field", message: "Please fill all the Fields")
            return
        }
        
        
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty || confrimPassword.isEmpty {
            showAlert(title: "Empty Field", message: "Please fill all the Fields")
            return
        }
        
        if password != confrimPassword {
            showAlert(title: "InCorrect Password", message: "Password does not match!! take a look")
            return
        }
        
        if isEmailAlreadyRegistered(email: email) {
            showAlert(title: "Email Incorrect", message: "Email address is already registered.")
            return
        }
        
        saveUserData(firstName: firstName, lastName: lastName, email: email, password: password)
        
        clearAllTextFieldData()
    }
    
    func saveUserData(firstName:String, lastName: String, email: String, password: String) {
        let userData = Signup(context: context)
        userData.firstName = firstName
        userData.lastName = lastName
        userData.email = email
        userData.password = password
        
        do {
            try context.save()
            print("UserData saved succesfully")
            showAlert(title: "Registration Successful", message:  "You have successfully registered!")
        } catch {
            print("Error while saving data")
        }
    }
    
    func clearAllTextFieldData() {
        firstNameTextField.text?.removeAll()
        lastNameTextField.text?.removeAll()
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
        confrimPasswordTextField.text?.removeAll()
    }
    
    func showAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    func isEmailAlreadyRegistered(email: String) -> Bool {
        return userData.contains { $0.email == email }
    }
    
    func fetchData() {
        let fetchRequest = NSFetchRequest<Signup>(entityName: "Signup")
        do {
            userData = try context.fetch(fetchRequest)
        } catch {
            print("Error while fetching data")
        }
    }

}
