//
//  ControlUtil.swift
//  Winfo_Swift
//
//  Created by HwangSeungmin on 1/12/19.
//  Copyright © 2019 Min. All rights reserved.
//

import SkyFloatingLabelTextField
import UIKit
import SwiftMessages

class ControlUtil {
    // Define properties of text field - for required inputs - light green-blue
    static func setSkyFloatingTextFieldColor(textField: SkyFloatingLabelTextField, placeholder: String, title: String) {
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        textField.frame.size.height = 45
        
        textField.placeholder = placeholder
        textField.title = title
        
        textField.tintColor = overcastBlueColor // the color of the blinking cursor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    // Define properties of text field - for required inputs - light green-blue
    static func setSkyFloatingTextFieldColor(textField: SkyFloatingLabelTextField) {
        
        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        let darkGreyColor = UIColor(red: 52/255, green: 42/255, blue: 61/255, alpha: 1.0)
        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)
        
        textField.frame.size.height = 45
        
        //        textField.tintColor = overcastBlueColor // the color of the blinking cursor
        textField.textColor = darkGreyColor
        textField.lineColor = lightGreyColor
        textField.selectedTitleColor = overcastBlueColor
        textField.selectedLineColor = overcastBlueColor
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    // Define properties of text field - for other inputs - black color
    static func setSkyFloatingTextField(textField: SkyFloatingLabelTextField, placeholder: String, title: String) {
        
        textField.frame.size.height = 45
        
        textField.placeholder = placeholder
        textField.title = title
        
        textField.lineHeight = 1.0 // bottom line height in points
        textField.selectedLineHeight = 2.0
    }
    
    // 성공, 경고, 실패, 정보 등 안내 메시지를 출력
    static func ToastMessage(_ theme: Theme, title: String, content: String, duration: Double = 0.0) {
        
        let view = MessageView.viewFromNib(layout: .cardView)
        
        // Theme message elements with the warning style.
        view.configureTheme(theme)
        
        // Add a drop shadow.
        view.configureDropShadow()
        
        // Set message title, body, and icon. Here, we're overriding the default warning
        // image with an emoji character.
        //let iconText = ["🤔", "😳", "🙄", "😶"].sm_random()!
        view.configureContent(title: title, body: content)
        
        // Increase the external margin around the card. In general, the effect of this setting
        // depends on how the given layout is constrained to the layout margins.
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        view.button?.isHidden = true
        
        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        var config = SwiftMessages.Config()
        
        // Slide up from the bottom.
        //config.presentationStyle = .bottom
        
        // Display in a window at the specified window level: UIWindow.Level.statusBar
        // displays over the status bar while UIWindow.Level.normal displays under.
        config.presentationContext = .window(windowLevel: .alert)
        
        // Disable the default auto-hiding behavior.
        if duration == 0.0 {
            config.duration = .forever
        } else {
            config.duration = .seconds(seconds: duration)
        }
        // Dim the background like a popover view. Hide when the background is tapped.
        config.dimMode = .gray(interactive: true)
        
        // Disable the interactive pan-to-hide gesture.
        config.interactiveHide = false
        
        // Specify a status bar style to if the message is displayed directly under the status bar.
        config.preferredStatusBarStyle = .lightContent
        
        // Specify one or more event listeners to respond to show and hide events.
        //config.eventListeners.append() { event in
        //   if case .didHide = event { print("yep") }
        //}
        
        SwiftMessages.show(config: config, view: view)
    }
}
