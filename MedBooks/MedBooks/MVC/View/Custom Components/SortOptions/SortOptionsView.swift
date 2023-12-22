//
//  SortOptionsVie.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 21/12/23.
//

import Foundation
import UIKit

protocol SortOptionDelegate {
    func btnSortClicked(index: Int, title: String)
    func resetSort()
}

@IBDesignable
class SortOptionsView: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwButton: UIStackView!
    
    let nibName = "SortOptionsView"
    var contentView: UIView?
    var selectedIndex: Int?
    var delegate: SortOptionDelegate?
    
    var optionList: [String]? {
        didSet {
            self.setupSortOptions()
        }
    }
    
    @IBInspectable var titleText: String? {
        didSet {
            self.lblTitle.text = titleText
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
        contentView = view
        self.removeSortOptions()
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
    
    func setOptions(options: [String]) {
        self.optionList = options
    }
    
    func clearSelection() {
        self.selectedIndex = nil
        self.setupSortOptions()
    }
    
    private func setupSortOptions() {
        self.removeSortOptions()
        self.optionList?.enumerated().map({ index, title in
            let optionButton = self.getOptionButton(title: title, isSelected: self.selectedIndex != nil ? ((self.selectedIndex ?? 0) == index) : false)
            optionButton.tag = index
            optionButton.adjustFontSize()
            self.vwButton.addArrangedSubview(optionButton)
        })
    }
    
    private func getOptionButton(title: String, isSelected: Bool = false) -> UIButton {
        let btnSortOption = UIButton()
        btnSortOption.isSelected = isSelected
        btnSortOption.addTarget(self, action: #selector(btnSortClicked(sender: )), for: .touchUpInside)
        btnSortOption.setTitle(title, for: .selected)
        btnSortOption.setTitle(title, for: .normal)
        btnSortOption.titleLabel?.font = UIFont(name: "Noteworthy Bold", size: 13)
        btnSortOption.titleLabel?.font = UIFont(name: "Noteworthy Bold", size: 13)
        btnSortOption.layer.cornerRadius = 17.5
        btnSortOption.layer.borderWidth = isSelected ? 1 : 0
        btnSortOption.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        btnSortOption.setTitleColor(UIColor.gray, for: .normal)
        btnSortOption.setTitleColor(UIColor.black, for: .selected)
        btnSortOption.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
        btnSortOption.backgroundColor = UIColor(named: "sortSelectionColor")
        btnSortOption.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            btnSortOption.heightAnchor.constraint(equalToConstant: 35)
        ])
        return btnSortOption
    }
    
    private func removeSortOptions() {
        self.vwButton.arrangedSubviews.map({ $0.removeFromSuperview() })
    }
    
    @objc func btnSortClicked(sender: UIButton) {
        if let title = self.optionList?[sender.tag], self.selectedIndex != sender.tag {
            self.selectedIndex = sender.tag
            self.delegate?.btnSortClicked(index: sender.tag, title: title)
            self.setupSortOptions()
            return
        }
        
        self.clearSelection()
        self.delegate?.resetSort()
    }
}
