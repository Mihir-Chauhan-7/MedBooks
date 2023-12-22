//
//  BookCell.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import Kingfisher

public class BookCell: UITableViewCell {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var imgCover: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblAuthor: UILabel!
    @IBOutlet private weak var lblRatingAvg: UILabel!
    @IBOutlet private weak var lblRatingCount: UILabel!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties
    
    public var book: Book? {
        didSet {
            self.setData()
        }
    }
   
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    func setData() {
        guard let book = self.book else {
            return
        }
        self.lblTitle.text = book.title ?? ""
        self.lblAuthor.text = book.getAuthors()
        self.lblRatingAvg.text = String(describing: (book.ratingAvg ?? 0.0).rounded())
        self.lblRatingCount.text = String(describing: book.ratingCount ?? 0)
        
        if book.coverImageId != 0 {
            self.imgCover.kf.indicatorType = .activity
            self.imgCover.kf.setImage(with: URL(string: ApiManager.shared.coverUrl.replacingOccurrences(of: "<cover_i>", with: String(describing: book.coverImageId ?? 0))), placeholder: UIImage(named: "books"))
            return
        }
        
        self.imgCover.image = UIImage(named: "books")
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBAction
    
    
    
    //-----------------------------------------------------------------------------------------
    //MARK:- View Life Cycle
    
    public override func prepareForReuse() {
        self.lblTitle.text = ""
        self.lblAuthor.text = ""
        self.lblRatingAvg.text = ""
        self.lblRatingCount.text = ""
        self.imgCover.image = nil
        self.imgCover.kf.indicatorType = .none
    }
}
