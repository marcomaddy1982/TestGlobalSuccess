//
//  ContactsViewController.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Contacts

class ContactsViewController: UITableViewController {

    var viewModel = ContactsViewModel()
    var currentChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestForAccess { (access) in
            if access {
                self.viewModel.loadContacts {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        self.viewModel.observeChats {
            self.viewModel.isNewChat = false
            let chat = ChatsProvider.sharedInstance.chat(with: (self.viewModel.selectedContact?.identifier)!)
            self.performSegue(withIdentifier: Constants.kContactsToChatSegue, sender: chat)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBAction
    @IBAction func cancel(sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.contactsCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCellView", for: indexPath)
        cell.textLabel?.text = self.viewModel.contact(at: indexPath.row).givenName
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewModel.setSelectedContact(at: indexPath.row)
        
        self.viewModel.openChat(at: indexPath.row) { (isAlreadyOpened) in
            
            DispatchQueue.main.async {
                if isAlreadyOpened{ // When the user open an exsisting chat
                    let chat = ChatsProvider.sharedInstance.chat(with: (self.viewModel.selectedContact?.identifier)!)
                    self.performSegue(withIdentifier: Constants.kContactsToChatSegue, sender: chat)
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chat = sender as? Chat {
            let chatVc = segue.destination as! ChatViewController
            chatVc.viewModel.chat = chat
            chatVc.viewModel.chatRef = ChatsProvider.sharedInstance.chatRef.child(chat.id)
        }
    }
}
