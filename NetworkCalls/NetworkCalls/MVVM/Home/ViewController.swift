//
//  ViewController.swift
//  NetworkCalls
//
//  Created by Kavya Krishna K. on 26/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var txtFldEmail: UITextField!
    @IBOutlet var txtFldPassword: UITextField!
    
    // MARK: Internal
    private lazy var viewModel = { return LoginVM()}()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Button Actions
    
    /// Handles the action when the login button is clicked.
    /// - Parameter sender: The button that was clicked.
    @IBAction func loginButtonClicked(_ button: TransitionButton) {
        
        guard let emailId = self.txtFldEmail.text,self.txtFldEmail.hasText else {
            //CommonFunctions.showToast("emailValidate".localized, state: .error)
            return
        }
        
        guard Validator.isValidEmail(emailId) else {
            //CommonFunctions.showToast("emailValidationCheck".localized, state: .error)
            
            return
        }
        
        guard let password = self.txtFldPassword.text,self.txtFldPassword.hasText else {
           // CommonFunctions.showToast("passwordValidate".localized, state: .error)
            return
        }
        
        self.viewModel?.bindToLoginView = { message, code, userType in
            
            if code == "APIConstants.loginSuccessCode" {
                //                let vc = MainVC.instantiate(fromAppStoryboard: .main)
                //                self.show(vc, sender: self)
                
            } else {
                   // CommonFunctions.showToast(message, state: .error)
                return
            }
        }
        
        self.viewModel?.loginRequest = LoginRequestModel(userName: emailId, password: password)
        self.viewModel?.login()
    }
    

}

