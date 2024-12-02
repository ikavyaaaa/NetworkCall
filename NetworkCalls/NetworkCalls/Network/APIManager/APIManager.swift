//
//  APIManager.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation
import Alamofire
import UIKit

struct Header {

    static var appTokenHeader: HTTPHeaders {
        return [
            HTTPHeaderField.contentType : ContentType.json,
            HTTPHeaderField.authentication : "\(HTTPHeaderField.bearer) \("AppToken.shared.userToken")",
            HTTPHeaderField.acceptLanguage: "en"
        ]
    }

    static var appAccessTokenHeader: HTTPHeaders {
        return [
            HTTPHeaderField.contentType : ContentType.json,
            HTTPHeaderField.authentication : "\(HTTPHeaderField.bearer) \("AppToken.shared.accessToken")",
            HTTPHeaderField.acceptLanguage: "en"
        ]
    }

    static var languageHeader: HTTPHeaders {
        return [
            HTTPHeaderField.acceptLanguage: "en"
        ]
    }
}


class APIManager {
    
    static let shared = AppAPIManager()
    
  
    
    private init(){}
    
    // MARK: Almofire Post/Get Request
    func request<T:Decodable>(_ isHUD:Bool = true, url:String, method : HTTPMethod, param:[String:Any]?, header:HTTPHeaders?, file:[String:Any]? = nil, type:T.Type, fullAccess : Bool = false, encoding:Encoding = Encoding.JSON, isFromDMS: Bool = false, isFromGoogle : Bool = false, completion:@escaping (T?,Error?) -> ()) {
        
        if Reachability.isConnectedToNetwork() == false {
          //  CommonFunctions.showAlert("noInternet".localized) { _ in
                completion(nil,EPLError.noInternet)
            //}
            return
        }
        
        var urlStr : String?
        
        urlStr = (ServerConfiguration.BASE_URL.absoluteString + url).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        
        if isFromDMS {
            urlStr = (ServerConfiguration.DMS_BASE_URL.absoluteString + url).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        } else if isFromGoogle {
            urlStr = (url).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        }
        
        guard let urlValues = urlStr, let urls = URL.init(string: urlValues) else {return}
        
        // print("Api Header => \(header ?? [:])")
        print("Api Paramaters => \(String(describing: param))")
        print("Api => \(urls)")
     
        
        if isHUD {
            ProgressHUD.animate("", .quintupleDotDance,interaction: false)
            
        }
        let enc : ParameterEncoding = encoding == Encoding.URL ? URLEncoding(destination: .httpBody) : JSONEncoding.prettyPrinted
        
        AF.request(urls, method: method, parameters: param != nil ? param! : nil, encoding: enc, headers: header).responseDecodable {  (response: DataResponse<T, AFError>) in
            if isHUD {
                ProgressHUD.dismiss()
            }
            
            print("Status code:::>>",response.response?.statusCode as Any)
            if response.response?.statusCode == 401 || response.response?.statusCode == 403 {
                print("Call refresh token API>>")
                self.getRefreshToken(BaseResponse<TokenModel>.self) { success in
                    if success == true {
                        print("Api Header => \(header ?? [:])")
                        print("Api Paramaters => \(String(describing: param))")
                        print("Api => \(urls)")
                        AF.request(urls, method: method, parameters: param != nil ? param! : nil, encoding: enc, headers: header).responseDecodable {  (response: DataResponse<T, AFError>) in
                            if let error = response.error?.localizedDescription {
                               // CommonFunctions.showAlert(error)
                                print("refresh token error::>>>",error)
                            }
                            completion(response.value,response.error)
                        }
                    } else {
                        kSceneDelegate?.setLogin()
                    }
                }
            }
            print("Api Response => \(String(describing: try? JSONSerialization.jsonObject(with: response.data ?? Data())))")
            completion(response.value,response.error)
        }
    }
    
    
    
    // MARK: Almofire uploadMedia Request
    func uploadMedia<T:Decodable>(isHUD:Bool = true, url:String, method : HTTPMethod = .put, header:HTTPHeaders?, type:T.Type, fileData : Data, completion:@escaping (T?) -> ()) {
        ProgressHUD.animate("", .quintupleDotDance,interaction: false)
        print("Api Hitting and this method called => \(url)")
        
        guard let urls = URL.init(string: url) else {return}
        
        let header : HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type":"image/jpeg"]
        
        AF.upload(fileData, to: urls,method: method,headers: header).uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseDecodable(completionHandler: {  (response: DataResponse<T, AFError>) in
            if isHUD {
                ProgressHUD.dismiss()
            }
            if response.response?.statusCode == 401 || response.response?.statusCode == 403 {
                print("Call refresh token API>>")
                AppAPIManager.shared.getRefreshToken(BaseResponse<TokenModel>.self) { success in
                    if success == true {
                        print("fileData=>>",fileData)
                        print("urls=>>",urls)
                        print("method=>>",method)
                        print("header=>>",header)
                        AF.upload(fileData, to: urls,method: method,headers: header).uploadProgress(queue: .main, closure: { progress in
                            print("Upload Progress: \(progress.fractionCompleted)")
                        })
                        .responseDecodable(completionHandler: {  (response: DataResponse<T, AFError>) in
                            print("response",response)
                            
                            completion(response.value)
                            print("Api Response => \(String(describing: response.value))")
                        })
                        
                    }else {
                        kSceneDelegate?.setLogin()
                    }
                }
            }
            completion(response.value)
        })
    }
    
    
    
    // MARK: Almofire Upload Request
    func uploadRequest<T:Decodable>(_ isHUD:Bool = true, url:String, method : HTTPMethod, header:HTTPHeaders?, type:T.Type, encoding:Encoding = Encoding.JSON, fileData : ImageData = ImageData(), completion:@escaping (T?) -> ()) {
        
        
        let urlStr = (ServerConfiguration.BASE_URL.absoluteString + url).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) // testing dev
        
        guard let urlValues = urlStr, let urls = URL.init(string: urlValues) else {return}
        
        
        if isHUD {  ProgressHUD.animate("", .quintupleDotDance,interaction: false) }
        print("Api Hitting and this method called => \(urls)")
        
        let _ : ParameterEncoding = encoding == Encoding.URL ? URLEncoding.default : JSONEncoding.default
        
        AF.upload(multipartFormData: { multipartFormData in
            if fileData.key != "" {
                if let data = fileData.imageData, let fileName = fileData.fileName {
                    multipartFormData.append(data, withName: fileData.key , fileName: fileName, mimeType: "image/png")
                }
            }
        }, to: urls, method: method, headers: header)
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseDecodable(completionHandler: {  (response: DataResponse<T, AFError>) in
            if isHUD {
                ProgressHUD.dismiss()
            }
            completion(response.value)
            print("Api Response => \(String(describing: response.value))")
        })
    }
    
    

    func getRefreshToken<T: Decodable>(_ type: T.Type, completion: @escaping (Bool) -> ()) {
        let refreshTok = AppToken.shared.refreshToken
        let companyCode = AppToken.shared.companyCode
        
        let parameters: [String: Any] = [
            "refreshToken": refreshTok,
            "companyCode": companyCode
        ]
        
        
        let headers : HTTPHeaders = [HTTPHeaderField.acceptType : ContentType.json,
                                     HTTPHeaderField.acceptLanguage : LanguageArray.getlanguage(code: UserDefaults.languageCode ?? "en").apiCode]
        
//        let headers: HTTPHeaders = [
//            .contentType("application/json")
//        ]
        
        print("url=>>", AppAPI.refreshToken.url)
        print("parameters=>>", parameters)
        print("header=>>", headers)
        
        let urlStr = (ServerConfiguration.BASE_URL.absoluteString + AppAPI.refreshToken.url).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? ""
        
        AF.request(URL(string: urlStr)!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: BaseResponse<RefreshTokenModel>.self) { response in
            print("getRefreshTokenResponse=>>", response)
            
            switch response.result {
            case .success(let value):
                guard let responseData = value.data,
                      let accessToken = responseData.accessToken,
                      let refreshToken = responseData.refreshToken else {
                    completion(false)
                    return
                }
                
                AppToken.shared.accessToken = accessToken
                AppToken.shared.refreshToken = refreshToken
                
                if let companyCode = JWTUtility.extractCompanyCode(from: accessToken) {
                    print("Company Code: \(companyCode)")
                    AppToken.shared.companyCode = companyCode
                } else {
                    print("Failed to extract company code")
                }
                
                completion(true)
                
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completion(false)
            }
        }
    }

}

enum K3encoding {
    case JSON
    case URL
}

class AppToken {
    static let shared = AppToken()
    
    var refreshToken = "" {
        didSet {
            UserDefaults.standard.set(refreshToken, forKey: UserDefaultConstants.refreshToken)
        }
    }
    
    var userToken = "" {
        didSet {
            UserDefaults.standard.set(userToken, forKey: UserDefaultConstants.userToken)
        }
    }
    
    var accessToken = "" {
        didSet {
            UserDefaults.standard.set(accessToken, forKey: UserDefaultConstants.accessToken)
        }
    }
    
    var appId = "" {
        didSet {
            UserDefaults.standard.set(appId, forKey: UserDefaultConstants.appId)
        }
    }
    
    var companyCode = "" {
        didSet {
            UserDefaults.standard.set(companyCode, forKey: UserDefaultConstants.companyCode)
        }
    }
}
