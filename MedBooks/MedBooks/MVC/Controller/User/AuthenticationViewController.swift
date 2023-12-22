//
//  AuthenticationViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var btnLogin: UIButton!
    @IBOutlet private weak var btnSignup: UIButton!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupViews() {
        DispatchQueue.main.async {
            self.btnLogin.layer.cornerRadius = self.btnLogin.bounds.height / 2
            self.btnSignup.layer.cornerRadius = self.btnSignup.bounds.height / 2
            self.checkLogin()
        }
    }
    
    func checkLogin() {
        if let isLogin = UserDefaults.standard.value(forKey: UserDefaultKeys.userLogin) as? Bool {
            if isLogin {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
                    self.redirectToHome()
                })
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
    
    @IBAction func btnLoginClicked(sender: UIButton) {
        let viewController = UIStoryboard(name: AppStoryBoards.user, bundle: nil).instantiateViewController(withIdentifier: AppControllers.loginViewController) as! LoginViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnSignupClicked(sender: UIButton) {
        let viewController = UIStoryboard(name: AppStoryBoards.user, bundle: nil).instantiateViewController(withIdentifier: AppControllers.signUpViewController) as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}
