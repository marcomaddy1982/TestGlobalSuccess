//
//  ContactsViewModel.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Contacts
import Firebase

typealias AccessCompletitionHandler = (Bool)-> Void
typealias LoadContactsCompletitionHandler = () -> Void
typealias AddChatCompletitionHandler = (Bool) -> Void
typealias ObserveChatsCompletitionHandler = () -> Void

class ContactsViewModel: NSObject {

    private let contactStore = CNContactStore()
    private var contacts: [CNContact] = []
//    private lazy var chatRef = Database.database().reference().child(Constants.kChats)
    private var chatRefHandle: DatabaseHandle?
    var isNewChat: Bool = false
    var selectedContact: CNContact? = nil
    
    var contactsCount: Int {
        return self.contacts.count
    }
    
    deinit {
//        if let refHandle = chatRefHandle {
//            chatRef.removeObserver(withHandle: refHandle)
//        }
    }
    
    // MARK: Public implementation
    
    func loadContacts(completitionHandler: @escaping LoadContactsCompletitionHandler) {
        
        DispatchQueue.global().async {
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            var allContainers: [CNContainer] = []
            do {
                allContainers = try self.contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try self.contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            self.contacts = results
            completitionHandler()
        }
    }
    
    func contact(at index: Int) -> CNContact {
        return self.contacts[index]
    }
    
    func setSelectedContact(at index: Int) {
        self.selectedContact = self.contacts[index]
    }
    
    func requestForAccess(completionHandler: @escaping AccessCompletitionHandler) {
        
        DispatchQueue.global().async {
            
            let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
            
            switch authorizationStatus {
            case .authorized:
                completionHandler(true)
                
            case .denied, .notDetermined:
                self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                    if access {
                        completionHandler(access)
                    }
                    else {
                        if authorizationStatus == CNAuthorizationStatus.denied {
                            completionHandler(false)
                        }
                    }
                })
                
            default:
                completionHandler(false)
            }
        }
    }
    
    func openChat(at index: Int, completitionHandler:@escaping AddChatCompletitionHandler) {
        
        DispatchQueue.global().async {
            let contact = self.contact(at: index)
            let contactId = contact.identifier
            let name = contact.givenName
            
            if ChatsProvider.sharedInstance.isChatAlreadyOpened(contactId: contactId) {
                self.isNewChat = false
                completitionHandler(true)
                return
            }

            self.isNewChat = true
            let newChatRef = ChatsProvider.sharedInstance.chatRef.childByAutoId()
            let chatItem = [
                Constants.kChatContractId: contactId,
                Constants.kChatName: name
            ]
            newChatRef.setValue(chatItem)
            completitionHandler(false)
        }
    }

    func observeChats(completition: @escaping ObserveChatsCompletitionHandler) {
        
        DispatchQueue.global().async {
            self.chatRefHandle = ChatsProvider.sharedInstance.chatRef.observe(.childAdded, with: { snapshot in
                if self.isNewChat {
                    completition()
                }
            })
        }
    }
}
