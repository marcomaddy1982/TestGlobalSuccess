//
//  Constant.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation

struct Constants {

    /*
     * Segue Identifiers
     */
    static let kLogInToChatsSegue    = "LogInToChatsSegue"
    static let kChatsToChatSegue     = "ChatsToChatSegue"
    static let kContactsToChatSegue  = "ContactsToChatSegue"
    
    /*
     * UserDefault
     */
    static let kUserDefaultNickname  = "NICKNAME"
    
    /*
     * Attributes Key
     */
    static let kChats                = "chats"
    static let kMessages             = "messages"
    
    static let kChatContractId       = "contactId"
    static let kChatName             = "name"
    
    static let kMessageSenderId      = "senderId"
    static let kMessageSenderName    = "senderName"
    static let kMessageText          = "text"
    
    /*
     * LoginViewController
     */
    static let kBottomLayoutGuideConstraint: Float = 48.0
    
    /*
     * ChatViewController
     */
    static let kMessageCellHeight: Float = 15.0
    
    
}
