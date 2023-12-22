//
//  ApiManager.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 20/12/23.
//

import Foundation


class ApiManager {
    
    static let shared = ApiManager()
    var baseUrl = "https://openlibrary.org/search.json"
    var coverUrl = "https://covers.openlibrary.org/b/id/<cover_i>.jpg"
    var countryBaseUrl = "https://api.first.org/data/v1/countries"
    
    func getBooks(title: String, start: Int = 0, limit: Int = 10, completion: @escaping ((BookData) -> ())) {
        let parameters = ["title": title, "offset" : "\(start)", "limit" : "\(limit)"]
        if let url = self.generateURL(url: ApiManager.shared.baseUrl, params: parameters) {
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                if let data = data, let bookData = try? JSONDecoder().decode(BookData.self, from: data) {
                    DispatchQueue.main.async {
                        completion(bookData)
                    }
                    return
                }
                print(AlertMessages.errorFetchingBook)
            }.resume()
        }
    }
    
    func generateURL(url: String, params: [String: String]) -> URL? {
        if let url = URL(string: self.queryString(url, params: params) ?? "") {
            return url
        }
        
        return nil
    }
    
    func queryString(_ value: String, params: [String: String]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }

        return components?.url?.absoluteString
    }
    
    func getCountryList(completion: @escaping ((CountryData) -> ())) {
        if let url = self.generateURL(url: ApiManager.shared.countryBaseUrl, params: [:]) {
            URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
                if error == nil, let data = data {
                    if let jsonObject = try? JSONDecoder().decode(CountryData.self, from: data) {
                        DispatchQueue.main.async {
                            completion(jsonObject)
                        }
                    }
                    return
                }
                
                print(AlertMessages.errorFetchingCountries)
            }.resume()
        }
    }
}


