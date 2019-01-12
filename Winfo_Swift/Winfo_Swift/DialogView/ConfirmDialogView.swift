//
//  AlarmDialogView.swift
//  P1018
//
//  Created by khhwang on 23/10/2018.
//  Copyright © 2018 SnJ Mobile. All rights reserved.
//

import UIKit
import SwiftMessages
import SkyFloatingLabelTextField
//import DLRadioButton

// Ask whether to delete the task or not
class ConfirmDialogView: MessageView {

    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var barcodeTextField:
    SkyFloatingLabelTextField!
    var yesAction: (() -> Void)?
    var cancelAction: (() -> Void)?
        
    @IBAction func yesButtonAction() {
        yesAction?()
    }

    @IBAction func cancelButtonAction() {
        cancelAction?()
    }
    
    func initControl() {
        titleLabel2.text = "Barcode Number".localized
        ControlUtil.setSkyFloatingTextField(textField: barcodeTextField, placeholder: "Type the Barcode Number".localized, title: "Barcode Number".localized)
        yesButton.setTitle("Done".localized, for: .normal)
        cancelButton.setTitle("Cancel".localized, for: .normal)
    }
}
