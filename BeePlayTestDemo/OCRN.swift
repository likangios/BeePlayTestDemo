//
//  OCRN.swift
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/27.
//  Copyright © 2018年 luck. All rights reserved.
//

import UIKit
import RNCryptor

class OCRN: NSObject {

    public func encrypt(data: Data, withPassword password: String) -> Data{
        
        return RNCryptor.encrypt(data: data, withPassword: password);
        
    }

    
}
