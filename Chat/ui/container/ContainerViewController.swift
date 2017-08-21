//
//  ContainerViewController.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Firebase

class ContainerViewController: UIViewController {

    @IBOutlet weak var viewContainerLoginFlow: UIView!
    @IBOutlet weak var viewContainerChatsFlow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private implementation
    
    func setUpLayout() {
        let userDefault = UserDefaults.standard
        
        if Auth.auth().currentUser?.uid != nil, let _ = userDefault.string(forKey: Constants.kUserDefaultNickname) {
            self.viewContainerChatsFlow.isHidden = false
            self.viewContainerLoginFlow.isHidden = true
        } else {
            self.viewContainerChatsFlow.isHidden = true
            self.viewContainerLoginFlow.isHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
