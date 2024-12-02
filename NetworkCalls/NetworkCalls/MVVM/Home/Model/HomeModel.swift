//
//  HomeModel.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation

// MARK: - BaseDataResponse
public struct BaseDataResponse : Codable {
    public let code : String?
    public let message : String?
    
    public enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
}

// MARK: - BaseResponse
public struct BaseResponse<T:Codable> : Codable {
    public let code : String?
    public let message : String?
    public let data : T?
    
    public enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(T.self, forKey: .data)
    }
}


public struct BaseResponses<T:Codable> : Codable {
    public let code : String?
    public let message : String?
    public let data : [T]?
    
    public enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case data = "data"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([T].self, forKey: .data)
    }
}

struct EmptyData : Codable {
    
}

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
