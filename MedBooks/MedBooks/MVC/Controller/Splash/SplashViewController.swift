//
//  SplashViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit

class SplashViewController: UIViewController{
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var imgAppLogo: UIStackView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        self.splashIconAnimation()
    }
    
    // App icon animation
    func splashIconAnimation(){
        UIView.animate(withDuration: 0.2, animations: {
            self.imgAppLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }, completion: { (finish: Bool) in
            UIView.animate(withDuration: 0.2, animations: {
                self.imgAppLogo.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                
            }, completion:{(finish: Bool) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.imgAppLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                }, completion: { (finish: Bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.imgAppLogo.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        
                    }, completion:{(finish: Bool) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.imgAppLogo.transform = CGAffineTransform.identity
                        })
                    })
                })
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let viewController = UIStoryboard(name: AppStoryBoards.user, bundle: nil).instantiateViewController(withIdentifier: AppControllers.authenticationViewController) as! AuthenticationViewController
            let navigationController = UINavigationController(rootViewController: viewController)
            AppDelegate.shared.window?.rootViewController = navigationController
            AppDelegate.shared.window?.makeKeyAndVisible()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    
    
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
    
}
