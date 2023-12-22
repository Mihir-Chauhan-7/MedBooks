//
//  HomeViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit

class HomeViewController: UITabBarController {

    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setupView() {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.5843137255, green: 0.7411764706, blue: 0.6235294118, alpha: 1)
    }
}
