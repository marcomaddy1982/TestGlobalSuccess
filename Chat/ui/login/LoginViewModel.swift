//
//  LoginViewModel.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Firebase

typealias LoginSuccessCompletitionHandler = () -> Void
typealias LoginFailureCompletitionHandler = (Error) -> Void

class LoginViewModel: NSObject {

    // MARK: - Public implementation
    
    func loginWithSuccess(success:@escaping LoginSuccessCompletitionHandler, failure: @escaping LoginFailureCompletitionHandler) {
        DispatchQueue.global().async {
            Auth.auth().signInAnonymously(completion: { (user, error) in
                if let err:Error = error {
                    failure(err)
                    return
                }
                success()
            })
        }
    }
    
    func saveNickname(nickName: String) {
        DispatchQueue.global().async {
            let userDefault = UserDefaults.standard
            userDefault.set(nickName, forKey: Constants.kUserDefaultNickname)
            userDefault.synchronize()
        }
    }
}
