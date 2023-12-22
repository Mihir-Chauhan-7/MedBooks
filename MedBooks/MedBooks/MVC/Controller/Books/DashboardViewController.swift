//
//  ViewController.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    
    //-----------------------------------------------------------------------------------------
    //MARK:- IBOutlet
    
    @IBOutlet private weak var vwTopNavigation: TopNavigation!
    @IBOutlet private weak var tblBooks: UITableView!
    @IBOutlet private weak var vwEmpty: UIView!
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Properties

    private var footerLoader: UIActivityIndicatorView?
    private var currentPageCount = 0
    private var bookLimit = 10
    private var currentSortOrder: SortOptions?
    private var currentSearchItem: DispatchWorkItem?
    private var isFinished = false
    private var searchText: String?
    
    private var isLoading = false {
        didSet {
            self.tblBooks.isScrollEnabled = !self.isLoading
        }
    }
    
    private var bookData: BookData? {
        didSet {
            self.books.append(contentsOf: self.bookData?.docs ?? [])
        }
    }
    
    private var books = [Book]() {
        didSet {
            self.sortData()
        }
    }
    
    private var filteredBooks = [Book]() {
        didSet {
            self.reloadBooks()
        }
    }
    
    //-----------------------------------------------------------------------------------------
    //MARK:- Custom Methods
    
    private func setupView() {
        self.vwTopNavigation.logoImage = UIImage(named: "books")
        self.vwTopNavigation.titleText = AppConstants.appName
        self.vwTopNavigation.subTitleText = AppConstants.navigationSubTitle
        self.vwTopNavigation.delegate = self
        self.setupFooterLoader()
    }
    
    private func setupFooterLoader() {
        self.footerLoader = UIActivityIndicatorView(style: .large)
        self.footerLoader?.frame = CGRect(x: CGFloat(0), y: CGFloat(5), width: self.tblBooks.bounds.width, height: CGFloat(64))
        self.tblBooks.tableFooterView = self.footerLoader
    }
    
    private func getBooks(currentItem: DispatchWorkItem? = nil) {
        if !self.isLoading {
            if let searchItem = self.searchText {
                self.isLoading = true
                print("%% Search Item Executing for \(searchItem)")
                print("~~ Loading \(self.currentPageCount) - Total Records \(self.filteredBooks.count)")
                self.footerLoader?.startAnimating()
                ApiManager.shared.getBooks(title: searchItem, start: self.currentPageCount, limit: self.bookLimit) { bookData in
                    DispatchQueue.main.async {
                        if (currentItem != nil && !(currentItem?.isCancelled ?? true)) || currentItem == nil {
                            self.bookData = bookData
                            print("~~ Received \(self.currentPageCount) - Total Records \(self.filteredBooks.count)")
                            print("%% Finished for \(searchItem)")
                            self.isLoading = false
                            self.footerLoader?.stopAnimating()
                            if (self.bookData?.docs?.count ?? 0) <= 0 {
                                self.isFinished = true
                            }
                            return
                        }
                        
                        print("%% Not Handling for \(searchItem)")
                    }
                }
            }
        }
    }
    
    func reloadBooks() {
        UIView.transition(with: self.tblBooks, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tblBooks.reloadData()
            self.vwTopNavigation.setSortOptions(title: AppConstants.sortOptionTitle, options: self.filteredBooks.count > 0  ? SortOptions.allCases.map({ $0.rawValue }) : [] )
            self.vwEmpty.isHidden = self.filteredBooks.count > 0
        }, completion: nil)
    }
    
    func loadData() {
        if !self.isFinished {
            self.currentPageCount += self.bookLimit
            self.getBooks()
        }
    }
    
    func clearSearchData() {
        self.searchText = ""
        self.isFinished = false
        self.currentSortOrder = nil
        self.bookData = nil
        self.books = []
        self.filteredBooks = []
        self.vwTopNavigation.clearSortOptions()
        self.vwTopNavigation.setSortOptions(title: AppConstants.sortOptionTitle, options: [])
    }
    
    func sortData() {
        print("~~ Sorting Now")
        switch self.currentSortOrder {
            case .title:
            self.filteredBooks = self.books.sorted(by: { ($0.title ?? "").lowercased() < ($1.title ?? "").lowercased() })
            case .average:
                self.filteredBooks = self.books.sorted(by: { ($0.ratingAvg ?? 0.0) > ($1.ratingAvg ?? 0.0) })
            case .ratings:
                self.filteredBooks = self.books.sorted(by: { ($0.ratingCount ?? 0) > ($1.ratingCount ?? 0) })
            default:
                self.filteredBooks = self.books
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

    override func viewWillAppear(_ animated: Bool) {
        self.vwTopNavigation.searchBar.resignFirstResponder()
        self.vwTopNavigation.searchBar.text?.removeAll()
    }
}

//-----------------------------------------------------------------------------------------
//MARK:- Extensions

extension DashboardViewController: NavigationSearchDelegate {
 
    func searchTextChange(searchText: String) {
        if self.currentSearchItem != nil {
            self.currentSearchItem?.cancel()
            self.currentSearchItem = nil
            self.isLoading = false
            print("%% Canceling for \(self.searchText)")
        }
        
        self.clearSearchData()
        
        if searchText.count >= 3 {
            self.currentSearchItem = DispatchWorkItem {
                if let currentWork = self.currentSearchItem, !currentWork.isCancelled {
                    print("%% Old \(self.searchText ?? "") - new \(searchText)")
                    //self.clearSearchData()
                    self.searchText = searchText
                    self.getBooks(currentItem: currentWork)
                }
            }
            
            if let currentWork = self.currentSearchItem {
                self.vwEmpty.isHidden = true
                self.footerLoader?.startAnimating()
                self.footerLoader?.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: currentWork)
            }
        }
    }
    
    func sortOptionClicked(index: Int, title: String) {
        self.currentSortOrder = SortOptions.allCases[index]
        self.sortData()
    }
    
    func resetSort() {
        self.currentSortOrder = nil
        self.sortData()
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblBooks.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.book = self.filteredBooks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

extension DashboardViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
            if !self.isLoading && !self.isFinished {
                self.loadData()
            }
        }
    }
}
