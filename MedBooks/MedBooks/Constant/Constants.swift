//
//  Constants.swift
//  MedBooks
//
//  Created by Mihir Chauhan on 22/12/23
//

import Foundation

struct AlertMessages {

    static let errorFetchingBook = "Error Fetching Books."
    static let errorFetchingCountries = "Error Fetching Countries."
    static let emailEmpty = "Email address cannot be empty."
    static let passwordEmpty = "Password cannot be empty."
    static let userExist = "Email adress already registered."
    static let registerationSuccess = "Registeration success."
    static let loginSuccess = "Login success."
    static let incorrectPassword = "Incorrect Password."
    static let userNotFound = "User Not Found, Please register first."
}

struct AppControllers {
    static let homeViewController = "HomeViewController"
    static let authenticationViewController = "AuthenticationViewController"
    static let loginViewController = "LoginViewController"
    static let signUpViewController = "SignUpViewController"
}

struct AppStoryBoards {
    static let main = "Main"
    static let user = "User"
    
}

struct UserDefaultKeys {
    static let appUsers = "AppUsers"
    static let userLogin = "UserLogin"
}

struct AppConstants {
    
    static let appName = "MedBooks"
    static let navigationSubTitle = "Which topic interests you today?"
    static let sortOptionTitle = "Sort By:"
}

enum SortOptions: String, CaseIterable {
    case title = "Title"
    case average = "Average"
    case ratings = "Hits"
}
