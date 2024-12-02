//
//  HomeVM.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 02/12/24.
//

import Foundation


class LoginVM : NSObject {
    
    var bindToView : ((String, String) -> ()) = {_, _ in }
    var bindToLoginView : ((String, String, String) -> ()) = {_, _, _ in }
    private var params = [String : Any]()
    
    var loginRequest = LoginRequestModel() {
        didSet {
            params = [
                "userName" : loginRequest.userName,
                "password" : loginRequest.password
            ]
        }
    }
    
    func login()  {
        AppAPIManager.shared.request(false,url: AppAPI.login.url, method: .post, param: params, header: Header.languageHeader, type: BaseResponse<TokenModel>.self,encoding:.JSON) { (response,error) in
            
            if error != nil {
                let errorMessage = error?.localizedDescription ?? "Login failed"
                self.bindToLoginView(errorMessage, APIConstants.errorCode, "")
                return
            }
            
            guard let data = response, let message = data.message, let code = data.code, let accessToken = data.data?.accessToken, let refreshToken = data.data?.refreshToken, let appId = data.data?.appId else {
                self.bindToLoginView(response?.message ?? "Login failed", response?.code ?? "", "")
                return
            }
            
            if let companyCode = JWTUtility.extractCompanyCode(from: accessToken) {
                print("Company Code: \(companyCode)")
                AppToken.shared.companyCode = companyCode
            } else {
                print("Failed to extract company code")
            }
            
            AppToken.shared.accessToken = accessToken
            AppToken.shared.refreshToken = refreshToken
            AppToken.shared.appId = appId
            
            
            self.bindToLoginView(message, code, userType)
            
        }
    }
}
