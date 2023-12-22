//
//  FavouriteCell.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit

class FavouriteCell: UITableViewCell {
    
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblAuthor: UILabel!
    
    var indexPath: IndexPath!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction private func btnDeleteFavourite(_ sender: UIButton) {

    }
}
