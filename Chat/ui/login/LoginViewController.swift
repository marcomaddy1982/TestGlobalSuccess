//
//  LoginViewController.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var bottomLayoutGuideConstraint: NSLayoutConstraint!
    
    var viewModel: LoginViewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private implementation
    
    private func startLogin() {
        self.viewModel.loginWithSuccess(success: {
            
            if let nickName = self.textName.text {
                self.viewModel.saveNickname(nickName: nickName)
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.kLogInToChatsSegue, sender: nil)
            }
        }, failure: { (error) in
            self.showLoginErrorAlert(error: error)
        })
    }
    
    private func showUnReachableAlert() {
        DispatchQueue.main.async {
            
            () -> Void in
            
            let alert: UIAlertController = UIAlertController(title: AlertMessages.kAlert_Attention_Title, message: AlertMessages.kAlert_ConnectionLost_Message, preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: AlertMessages.kAlert_Common_Button_OK, style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoginErrorAlert(error: Error) {
        DispatchQueue.main.async {
            
            () -> Void in
            
            let alert: UIAlertController = UIAlertController(title: AlertMessages.kAlert_Attention_Title, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            let okButton = UIAlertAction(title: AlertMessages.kAlert_Common_Button_OK, style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: IBActions
    
    @IBAction func didPressLoginButton(_ sender: AnyObject) {
        let reachableBlock: ConnectivitySuccessBlock = {
            self.startLogin()
        }
        
        let unReachableBlock: ConnectivityFailureBlock = {
            self.showUnReachableAlert()
        }
        
        ConnectivityManager.sharedInstance.executeBlockIfConnectionIsAvailable(success: reachableBlock, failure: unReachableBlock)
    }
    
    // MARK: - Notifications
    
    func keyboardWillShowNotification(_ notification: Notification) {
        let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        bottomLayoutGuideConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    }
    
    func keyboardWillHideNotification(_ notification: Notification) {
        bottomLayoutGuideConstraint.constant = CGFloat(Constants.kBottomLayoutGuideConstraint)
    }
    
    // MARK - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if (textField.text?.characters.count)! > 0{
            buttonLogin.isEnabled = true
        } else {
            buttonLogin.isEnabled = false
        }

        return true
    }
}
