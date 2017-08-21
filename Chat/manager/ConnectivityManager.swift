//
//  ConnectivityManager.swift
//  Chat
//
//  Created by Marco Maddalena on 21/08/2017.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit
import ReachabilitySwift

typealias ConnectivitySuccessBlock = () -> Void
typealias ConnectivityFailureBlock = () -> Void

private let _sharedInstance = ConnectivityManager()

class ConnectivityManager: NSObject {

    var reachability: Reachability
    
    // MARK: lifecycle
    
    override init() {
        reachability = Reachability.init()!
    }
    
    class var sharedInstance: ConnectivityManager {
        return _sharedInstance
    }
    
    // MARK: public implementation
    
    func isNetworkAvailable() -> Bool {
        return reachability.isReachable
    }
    
    func executeBlockIfConnectionIsAvailable(success: @escaping ConnectivitySuccessBlock, failure: @escaping ConnectivityFailureBlock) {
        
        if (ConnectivityManager.sharedInstance.isNetworkAvailable()){
            success()
        } else {
            failure()
        }
    }
}
