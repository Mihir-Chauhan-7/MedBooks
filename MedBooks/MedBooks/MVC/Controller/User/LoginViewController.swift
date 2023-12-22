//
//  LoginViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var vwLoginForm: UIScrollView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    
    func setupViews() {
        DispatchQueue.main.async {
            self.btnLogin.layer.cornerRadius = self.btnLogin.bounds.height / 2
        }
    }
    
    func checkLogin() {
        if isValidInput() {
            if let email = self.txtEmail.text, let password = self.txtPassword.text {
                
                if let data = UserDefaults.standard.value(forKey: UserDefaultKeys.appUsers) as? Data {
                    let currentUsers = try? PropertyListDecoder().decode(Array<User>.self, from: data)
                    if let existingUser = currentUsers?.filter({ $0.email == email }), existingUser.count > 0 {
                        if existingUser.first?.password ?? "" == password {
                            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.userLogin)
                            self.presentAlertController(.alert, title: AlertMessages.loginSuccess) { _ in
                                self.redirectToHome()
                            }
                            return
                        }
                        self.presentAlertController(.alert, title: AlertMessages.incorrectPassword)
                        return
                    }
                
                    self.presentAlertController(.alert, title: AlertMessages.userNotFound)
                }
            }
           
        }
    }
    
    func isValidInput() -> Bool {
        
        guard !self.txtEmail.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.emailEmpty)
            return false
        }
        
        
        guard !self.txtPassword.text!.isEmpty else {
            self.presentAlertController(.alert, message: AlertMessages.passwordEmpty)
            return false
        }
        
        let errorMsgs = self.getMissingValidation(str: self.txtPassword.text!)

        if errorMsgs.count > 0 {
            self.presentAlertController(.alert, title: "Your password must contain:", message: errorMsgs.joined(separator: ", "))
            return false
        }
        
        return true
    }
    
    func redirectToHome() {
        let viewController = UIStoryboard(name: AppStoryBoards.main, bundle: nil).instantiateViewController(withIdentifier: AppControllers.homeViewController) as! HomeViewController
        AppDelegate.shared.window?.rootViewController = viewController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }

    func getMissingValidation(str: String) -> [String] {
        var errors: [String] = []
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: str)){
            errors.append("One uppercase")
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: str)){
            errors.append("One number")
        }

        if(!NSPredicate(format:"SELF MATCHES %@", ".*[!&^%$#@()/]+.*").evaluate(with: str)){
            errors.append("One special character")
        }
        
        if(str.count < 8){
            errors.append("Min 8 characters")
        }
        return errors
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    @IBAction func btnLoginClicked(_ sender: UIButton) {
        self.checkLogin()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Memory Management
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
    }
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension LoginViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case txtEmail:
                self.txtEmail.resignFirstResponder()
                self.txtPassword.becomeFirstResponder()
            case txtPassword:
                self.txtPassword.resignFirstResponder()
                self.checkLogin()
            
            default: textField.resignFirstResponder()
        }
            
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.vwLoginForm.setContentOffset(CGPoint(x: 0, y: (textField.superview?.frame.origin.y)!), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.vwLoginForm.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}
