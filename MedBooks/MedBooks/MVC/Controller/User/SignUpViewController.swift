//
//  SignUpViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import CoreData


class SignUpViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var txtEmail: UITextField!
    @IBOutlet private weak var txtPassword: UITextField!
    @IBOutlet private weak var vwPicker: UIPickerView!
    @IBOutlet private weak var btnSignUp: UIButton!
    @IBOutlet private weak var vwSignUpForm: UIScrollView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    var countryData: CountryData?
    var countryTitles: [String]?
    var defaultSelected = "India"
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        DispatchQueue.main.async {
            self.btnSignUp.layer.cornerRadius = self.btnSignUp.bounds.height / 2
            ApiManager.shared.getCountryList { countryData in
                self.countryData = countryData
                self.countryTitles = self.countryData?.data.countryType.compactMap({ $0.value.country })
                self.vwPicker.dataSource = self
                self.vwPicker.delegate = self
                self.vwPicker.selectRow(self.countryTitles?.firstIndex(of: self.defaultSelected) ?? 0, inComponent: 0, animated: true)
            }
        }
    }
    
    func clearForm() {
        self.txtEmail.text?.removeAll()
        self.txtPassword.text?.removeAll()
        self.vwSignUpForm.endEditing(true)
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
    
    public func isValidPassword(value: String) -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: value)
    }
    
    func validateSignUp() {
        if self.isValidInput() {
            if let email = self.txtEmail.text, let password = self.txtPassword.text {
                if let countryIndex = self.vwPicker.selectedRow(inComponent: 0) as? Int, let country = self.countryTitles?[countryIndex] {
                    if let data = UserDefaults.standard.value(forKey: UserDefaultKeys.appUsers) as? Data {
                        var currentUsers = try? PropertyListDecoder().decode(Array<User>.self, from: data)
                        if let existingUser = currentUsers?.filter({ $0.email == email }), existingUser.count > 0 {
                            self.presentAlertController(.alert, message: AlertMessages.userExist)
                        } else {
                            let newUser = User(email: email, password: password, country: country)
                            currentUsers?.append(newUser)
                            UserDefaults.standard.set(try? PropertyListEncoder().encode(currentUsers), forKey: UserDefaultKeys.appUsers)
                            UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.userLogin)
                            self.presentAlertController(.alert, message: AlertMessages.registerationSuccess) { _ in
                                self.redirectToHome()
                            }
                        }
                    } else {
                        let newUser = User(email: email, password: password, country: country)
                        UserDefaults.standard.set(try? PropertyListEncoder().encode([newUser]), forKey: UserDefaultKeys.appUsers)
                        UserDefaults.standard.setValue(true, forKey: UserDefaultKeys.userLogin)
                        self.presentAlertController(.alert, message: AlertMessages.registerationSuccess) { _ in
                            self.redirectToHome()
                        }
                    }
                }
            }
        }
    }
    
    func redirectToHome() {
        let viewController = UIStoryboard(name: AppStoryBoards.main, bundle: nil).instantiateViewController(withIdentifier: AppControllers.homeViewController) as! HomeViewController
        AppDelegate.shared.window?.rootViewController = viewController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    @IBAction func btnSignUpClicked(_ sender: UIButton) {
        self.validateSignUp()
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
        self.setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearForm()
    }
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension SignUpViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case txtEmail:
                self.txtEmail.resignFirstResponder()
                self.txtPassword.becomeFirstResponder()
            case txtPassword:
                self.txtPassword.resignFirstResponder()
                self.vwPicker.becomeFirstResponder()
                self.validateSignUp()
            
            default: textField.resignFirstResponder()
        }
            
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.vwSignUpForm.setContentOffset(CGPoint(x: 0, y: (textField.superview?.frame.origin.y)!), animated: true)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.vwSignUpForm.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryTitles?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.countryTitles?[row] ?? ""
    }
}
