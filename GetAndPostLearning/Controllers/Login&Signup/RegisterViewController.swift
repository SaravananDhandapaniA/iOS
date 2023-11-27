//
//  RegisterViewController.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 28/06/23.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var userData:[Register] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromDB()
        profileImageView.makeRounded()
        profileImageAction()
        phoneTextField.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Registered"), object: nil, queue: nil) { _ in
            self.fetchDataFromDB()
        }
    }
    
    @objc
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        openGallery()
    }
    
    @IBAction func registerBtnTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
              let phone = phoneTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              let confrimPassword  = confirmPasswordTextField.text else {
            showAlert(title: "Empty Field", message: "Please fill all the Fields")
            return
        }
        
        guard let phoneNumber = Int32(phone) else { return }
        
        if username.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty || confrimPassword.isEmpty {
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
        
        saveUserData(username: username, phone: phoneNumber, email: email, password: password)
        NotificationCenter.default.post(Notification(name: Notification.Name("Registered"), object: nil))
        clearAllTextFieldData()
    }

}

extension RegisterViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .savedPhotosAlbum
            present(picker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    
    
    func saveUserData(username:String, phone: Int32, email: String, password: String) {
        let userData = Register(context: context)
        userData.username = username
        userData.phone = phone
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
}

extension RegisterViewController {
    
    func profileImageAction() {
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapImageGesture)
    }
    
    func isEmailAlreadyRegistered(email: String) -> Bool {
        return userData.contains { $0.email == email }
    }
    
    func showAlert(title: String, message:String) {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    func clearAllTextFieldData() {
        usernameTextField.text?.removeAll()
        phoneTextField.text?.removeAll()
        emailTextField.text?.removeAll()
        passwordTextField.text?.removeAll()
        confirmPasswordTextField.text?.removeAll()
    }
    
}
