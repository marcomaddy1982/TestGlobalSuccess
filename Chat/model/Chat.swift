//
//  Chat.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import Firebase
import JSQMessagesViewController

internal class Chat {
    internal let id: String
    internal var contactId: String? = nil
    internal var name: String? = nil
    internal var reference: DatabaseReference?
    
    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        let snapshotValue = snapshot.value as! Dictionary<String, AnyObject>
        
        if let aContactId = snapshotValue[Constants.kChatContractId] as? String {
            contactId = aContactId
        }
        if let aName = snapshotValue[Constants.kChatName] as? String {
            name = aName
        }
        if let ref = snapshot.ref as? DatabaseReference{
            reference = ref
        }
    }
}

extension Chat: Equatable {}

func ==(lhs: Chat, rhs: Chat) -> Bool {
    let areEqual = lhs.contactId == rhs.contactId
    return areEqual
}
