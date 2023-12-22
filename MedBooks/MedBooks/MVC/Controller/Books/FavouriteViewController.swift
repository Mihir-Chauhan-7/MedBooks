//
//  FavouriteViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import CoreData

class FavouriteViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var topNavigation: TopNavigation!
    @IBOutlet private weak var tblFavourite: UITableView!
    @IBOutlet private weak var btnLogout: UIButton!
    @IBOutlet private weak var emptyView: UIView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    

    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        self.getFavourites()
    }
    
    @objc func getFavourites() {

    }
    
    func redirectToAuthentication() {
        let viewController = UIStoryboard(name: AppStoryBoards.user, bundle: nil).instantiateViewController(withIdentifier: AppControllers.authenticationViewController) as! AuthenticationViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        AppDelegate.shared.window?.rootViewController = navigationController
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    @IBAction func btnLogoutClicked(sender: UIButton) {
        UserDefaults.standard.setValue(false, forKey: UserDefaultKeys.userLogin)
        self.redirectToAuthentication()
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
        self.topNavigation.searchBar.resignFirstResponder()
        self.topNavigation.searchBar.text?.removeAll()
    }
    
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions


extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblFavourite.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
