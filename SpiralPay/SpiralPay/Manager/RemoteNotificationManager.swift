//
//  RemoteNotificationManager.swift
// WordPower
//
//  Created by Zoeb on 19/06/17.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import UIKit

class RemoteNotificationManager: NSObject {
    var userConversationThreadId: NSNumber = NSNumber.init(value: 0)
    var postActivityId: NSNumber = NSNumber.init(value: 0)
    
    public func showAlertAfterRemoteNotification(userInfo: Dictionary<String, Any>) {
        
    }
    
    public func resetNotificationTray(block: () -> ()) {
        
    }
}
