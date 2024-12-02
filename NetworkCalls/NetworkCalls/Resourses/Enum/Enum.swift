//
//  Enum.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation

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
            return  "https://abcd.com/api/"
        case .staging :
            return "https://abcdstaging.com/api/"
        case .production :
            return "https://abcd.com/api/"
        }
    }
}
