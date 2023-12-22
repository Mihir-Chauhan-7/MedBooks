//
//  UIViewController+Alert.swift
//  HealthApp
//
//  Created by Mihir Chauhan on 20/08/20.
//  Copyright © 2020 macbook air. All rights reserved.
//

import Foundation
import UIKit

//---------------------------------------------------------
//MARK: - Alert Button Type
struct AlertActionType {
    
    var title : String
    var type : UIAlertAction.Style

    init() {
        self.title = ""
        self.type = .default
    }
    
    init(_ title : String ,type : UIAlertAction.Style = .default) {
        
        self.title = title
        self.type = type
    }
}

//---------------------------------------------------------

extension UIViewController {
    
    func presentAlertController(_ preferredStyle : UIAlertController.Style
        , title : String? = nil
        , message : String? = nil
        , buttons : [AlertActionType] = [AlertActionType("OK")]
        , sourceView : Any? = nil
        ,withCompletion block : ((Int) -> Void)? = nil) {
        
        let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for button in buttons {
            
            let action : UIAlertAction = UIAlertAction(title: button.title, style: button.type, handler: { (action : UIAlertAction) in
                
                let index = buttons.firstIndex{$0.title == button.title}
                block?(index!)
                
            })
            
            alert.addAction(action)
        }
        
        switch preferredStyle {
        case .alert:
            self.present(alert, animated: true, completion: nil)
            break
        case .actionSheet:
            self.present(alert, from: sourceView ?? self.view)
            break
        @unknown default:
            fatalError()
        }
    }
    
    private func present(_ alertController: UIAlertController, from source: Any?){
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            let popPresenter = alertController.popoverPresentationController
            if source is UIBarButtonItem {
                popPresenter?.barButtonItem = source as? UIBarButtonItem
                popPresenter?.sourceView = self.view
                popPresenter?.sourceRect = self.view.bounds
            } else {
                popPresenter?.sourceView = source as? UIView
                popPresenter?.sourceRect = ((source as? UIView)?.frame)!
            }

            self.present(alertController, animated: true, completion: nil)
        }else{
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
