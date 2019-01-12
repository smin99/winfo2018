//
//  StringExtension.swift
//  Winfo_Swift
//
//  Created by HwangSeungmin on 1/12/19.
//  Copyright © 2019 Min. All rights reserved.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
