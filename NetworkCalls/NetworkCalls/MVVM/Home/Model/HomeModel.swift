//
//  HomeModel.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation

public struct TokenModel : Codable {
    public let accessToken : String?
    public let refreshToken : String?
    public let appId : String?
    public let region : String?
    public let DEVICE_CODE : String?
    public let UserType : String?
  
    public enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case appId = "appId"
        case region = "region"
        case DEVICE_CODE = "DEVICE_CODE"
        case UserType = "UserType"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken)
        refreshToken = try values.decodeIfPresent(String.self, forKey: .refreshToken)
        appId = try values.decodeIfPresent(String.self, forKey: .appId)
        region = try values.decodeIfPresent(String.self, forKey: .region)
        DEVICE_CODE = try values.decodeIfPresent(String.self, forKey: .DEVICE_CODE)
        UserType = try values.decodeIfPresent(String.self, forKey: .UserType)
    }
}
