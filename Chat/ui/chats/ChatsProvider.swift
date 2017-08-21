//
//  ChatsViewModel.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Contacts
import Firebase

typealias ChatsCompletitionHandler = () -> Void

private let _sharedInstance = ChatsProvider()

class ChatsProvider: NSObject {

    lazy var chatRef = Database.database().reference().child(Constants.kChats)
    private var chatRefHandleAdd: DatabaseHandle?
    private var chatRefHandleRemove: DatabaseHandle?
    private var chats:[Chat] = []
    
    class var sharedInstance: ChatsProvider {
        return _sharedInstance
    }
    
    deinit {
        if let refHandle = chatRefHandleAdd {
            chatRef.removeObserver(withHandle: refHandle)
        }
        
        if let refHandle = chatRefHandleRemove {
            chatRef.removeObserver(withHandle: refHandle)
        }
    }
    
    var chatsCount: Int {
        return self.chats.count
    }
    
    // MARK: - Public implementation
    
    func observeChatsWithCompletitionHandler(completition:@escaping ChatsCompletitionHandler) {
        DispatchQueue.global().async {
            self.chatRefHandleAdd = self.chatRef.observe(.childAdded, with: { snapshot in
                let chatItem = Chat(snapshot: snapshot)
                self.chats.append(chatItem)
                completition()
            })
            
            self.chatRefHandleRemove = self.chatRef.observe(.childRemoved, with: { snapshot in
                let chatItem = Chat(snapshot: snapshot)
                if let index = self.chats.index(where: {$0.contactId == chatItem.contactId}){
                    self.chats.remove(at: index)
                    
                }
                completition()
            })
        }
    }
    
    func removeChat(at index: Int) {
        DispatchQueue.global().async {
            let chat = self.chats[index]
            chat.reference?.removeValue()
        }
    }
    
    func chat(at index: Int) -> Chat {
        return self.chats[index]
    }
    
    func chat(with contactId: String) -> Chat? {
        for chat in self.chats {
            if chat.contactId == contactId {
                return chat
            }
        }
        
        return nil
    }
    
    func isChatAlreadyOpened(contactId: String) -> Bool {
        for chat in self.chats {
            if chat.contactId == contactId {
                return true
            }
        }
        
        return false
    }
}
