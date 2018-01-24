//
//  StringExtention.swift
//  SpiralPay
//
//  Created by Zoeb  on 16/01/18.
//  Copyright (c) 2018 EnvisionWorld. All rights reserved.
//

import Foundation

extension String {
    
    func localize() -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
}
