//
//  ChatViewModel.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

typealias ChatCompletitionHandler = () -> Void

class ChatViewModel: NSObject {

    var chatRef: DatabaseReference? {
        didSet{
            messageRef = chatRef?.child(Constants.kMessages)
        }
    }
    private var messageRef: DatabaseReference?
    private var newMessageRefHandle: DatabaseHandle?
    
    var chat: Chat?
    
    private var messages: [JSQMessage] = []
    
    var messagesCount: Int {
        return self.messages.count
    }
    
    // MARK: Public implementation
    
    func observeMessages(completition:@escaping ChatCompletitionHandler) {
        DispatchQueue.global().async {
            
            let messageQuery = self.messageRef?.queryLimited(toLast:25)
            
            self.newMessageRefHandle = messageQuery?.observe(.childAdded, with: { (snapshot) -> Void in
                let messageData = snapshot.value as! Dictionary<String, String>
                
                if let id = messageData[Constants.kMessageSenderId] as String!, let name = messageData[Constants.kMessageSenderName] as String!, let text = messageData[Constants.kMessageText] as String!, text.characters.count > 0 {
                    
                    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
                        self.messages.append(message)
                    }
                    
                    completition()
                }
            })
        }
    }
    
    func removeObserver() {
        if let refHandle = newMessageRefHandle {
            messageRef?.removeObserver(withHandle: refHandle)
        }
    }
    
    func sendMessage(senderId:String, senderDisplayName:String, text:String, completition:@escaping ChatCompletitionHandler) {
        DispatchQueue.global().async {
            let itemRef = self.messageRef?.childByAutoId()
            
            let messageItem = [
                Constants.kMessageSenderId: senderId,
                Constants.kMessageSenderName: senderDisplayName,
                Constants.kMessageText: text,
                ]
            
            itemRef?.setValue(messageItem)
            completition()
        }
    }
    
    func message(at index: Int) -> JSQMessage {
        return self.messages[index]
    }
}
