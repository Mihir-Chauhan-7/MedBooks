//
//  TopNavigation.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import Foundation
import UIKit

@objc protocol NavigationSearchDelegate {
    func searchTextChange(searchText: String)
    @objc optional func sortOptionClicked(index: Int, title: String)
    @objc optional func resetSort()
}

@IBDesignable
class TopNavigation: UIView {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet private weak var vwSortOptions: SortOptionsView!
    
    let nibName = "TopNavigation"
    var delegate: NavigationSearchDelegate?
    var contentView: UIView?
    
    @IBInspectable var titleText: String? {
        didSet {
            self.lblTitle.text = titleText
        }
    }
    
    @IBInspectable var subTitleText: String? {
        didSet {
            self.lblSubTitle.text = subTitleText
        }
    }
    
    @IBInspectable var logoImage: UIImage? {
        didSet {
            self.imgLogo.image = logoImage
        }
    }
    
    @IBInspectable var searchPlaceholder: String? {
        didSet {
            self.searchBar.placeholder = searchPlaceholder
        }
    }
    
    @IBInspectable var isSearchBarHidden: Bool = true {
        didSet {
            self.searchBar.isHidden = !isSearchBarHidden
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.contentView = view
        self.handleSearchBarClear()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.contentView?.prepareForInterfaceBuilder()
    }
    
    func setSortOptions(title: String, options: [String]) {

        if options.count > 0 {
            self.vwSortOptions.isHidden = false
            self.vwSortOptions.delegate = self
            self.vwSortOptions.titleText = title
            self.vwSortOptions.setOptions(options: options)
            return
        }
        
        self.vwSortOptions.isHidden = true
    }
    
    func clearSortOptions() {
        self.vwSortOptions.clearSelection()
    }
    
    func handleSearchBarClear() {
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField , let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {

             clearButton.addTarget(self, action: #selector(self.searchBarClearClicked), for: .touchUpInside)
        }
    }
    
    @objc func searchBarClearClicked() {
        self.delegate?.searchTextChange(searchText: "")
        self.vwSortOptions.clearSelection()
        self.delegate?.resetSort?()
    }
}

extension TopNavigation: UISearchBarDelegate, SortOptionDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.delegate?.searchTextChange(searchText: searchText.lowercased())
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func btnSortClicked(index: Int, title: String) {
        self.delegate?.sortOptionClicked?(index: index, title: title)
    }
    
    func resetSort() {
        self.delegate?.resetSort?()
    }
}
