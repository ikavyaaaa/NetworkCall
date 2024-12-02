//
//  Enum.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation

enum AppStoryboard: String {
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \("file") \nLine Number : \("line") \nFunction : \("function")")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    func initialTabViewController() -> UITabBarController? {
        return instance.instantiateInitialViewController()
    }
    
}

enum Encoding {
    case JSON
    case URL
}

enum HTTPHeaderField {
    static let authentication  = "Authorization"
    static let contentType     = "Content-Type"
    static let acceptType      = "Accept"
    static let acceptEncoding  = "Accept-Encoding"
    static let acceptLangauge  = "accept-Language"
    static let bearer          = "Bearer"
    static let application     = "Application"
    static let timezone        = "time-zone"
    static let acceptLanguage  = "accept-language"
    static let grantType       = "grant_type"
}

enum ContentType {
    static let json            = "application/json"
    static let multipart       = "multipart/form-data"
    static let urlencoded      = "application/x-www-form-urlencoded"
    static let ENUS            = "en-us"
}

enum MultipartType {
    static let image = "Image"
    static let csv = "CSV"
}

enum MimeType {
    static let image = "image/png"
    static let csvText = "text/csv"
    static let formData = "application/x-www-form-urlencoded"
}

enum AppAPI {
    case login
    
    var url: String {
        switch self {
        case .login:
            "loginMobile"
        }
    }
}
    
enum AppBaseURL {
    case development
    case staging
    case production
    
    var desc : String {
        switch self {
        case .development :
            return  "https://abcddev.com/api/"
        case .staging :
            return "https://abcdstaging.com/api/"
        case .production :
            return "https://abcd.com/api/"
        }
    }
}
