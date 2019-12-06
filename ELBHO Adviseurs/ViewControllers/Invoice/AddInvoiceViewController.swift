//
//  AddInvoiceViewController.swift
//  ELBHO Adviseurs
//
//  Created by Bas Tolen on 06/12/2019.
//  Copyright © 2019 Otters. All rights reserved.
//

import UIKit
import MaterialComponents
import MobileCoreServices

class AddInvoiceViewController: UIViewController {
    @IBOutlet weak var SubmitButton: MDCButton!
    @IBOutlet weak var SubmitButtonBottomConstraint: NSLayoutConstraint!
    
    var yearController: MDCTextInputControllerUnderline?
    @IBOutlet weak var yearInputField: MDCTextField!
    var years = ["2018", "2019", "2020", "2021", "2022"]
    
    var monthController: MDCTextInputController?
    @IBOutlet weak var monthInputField: MDCTextField!
    var selectedMonth: Int?;
    var months = [
        "month_1".localize,
        "month_2".localize,
        "month_3".localize,
        "month_4".localize,
        "month_5".localize,
        "month_6".localize,
        "month_7".localize,
        "month_8".localize,
        "month_9".localize,
        "month_10".localize,
        "month_11".localize,
        "month_12".localize
    ]
    
    var fileController: MDCTextInputController?
    @IBOutlet weak var fileInputField: MDCTextField!
    var fileURL: URL?
    
    let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "title_invoice".localize
        setupInputFields()
        hideKeyboardWhenTappingOutside()
        SubmitButton.setPrimary()
        SubmitButton.setTitle("button_addinvoice".localize, for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func FileInputTouched(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document", kUTTypePDF as String], in: .open)
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true)
    }
    
    @IBAction func SubmitClicked(_ sender: Any) {
        print("Clicked")
    }
    
    private func setupInputFields() {
        yearController = MDCTextInputControllerUnderline(textInput: yearInputField)
        yearController?.activeColor = UIColor(named: "Primary")
        yearInputField.placeholderLabel.text = "input_year".localize
        yearInputField.placeholderLabel.textColor = UIColor(named: "Primary")!
        yearInputField.clearButtonMode = .never
        
        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.tag = 1
        yearInputField.inputView = yearPicker
        yearInputField.inputAccessoryView = toolBar
        
        monthController = MDCTextInputControllerUnderline(textInput: monthInputField)
        monthController?.activeColor = UIColor(named: "Primary")
        monthInputField.placeholderLabel.text = "input_month".localize
        monthInputField.placeholderLabel.textColor = UIColor(named: "Primary")!
        monthInputField.clearButtonMode = .never
        
        let monthPicker = UIPickerView()
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthPicker.tag = 2
        monthInputField.inputView = monthPicker
        monthInputField.inputAccessoryView = toolBar
        
        fileController = MDCTextInputControllerUnderline(textInput: fileInputField)
        fileController?.activeColor = UIColor(named: "Primary")
        fileInputField.placeholderLabel.text = "input_file".localize
        fileInputField.placeholderLabel.textColor = UIColor(named: "Primary")!
        fileInputField.clearButtonMode = .never
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (SubmitButtonBottomConstraint.constant < keyboardSize.height) {
                SubmitButtonBottomConstraint.constant = 20 + keyboardSize.height
            }
        }
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if (SubmitButtonBottomConstraint.constant > keyboardSize.height) {
                SubmitButtonBottomConstraint.constant = 20
            }
        }
    }
}

extension AddInvoiceViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return years.count
        } else {
            return months.count;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return years[row]
        } else {
            return months[row];
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            yearInputField.text = years[row]
        } else {
            selectedMonth = row
            monthInputField.text = months[row]
        }
    }
}

extension AddInvoiceViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
}

extension AddInvoiceViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        // File location
        print(url)
        fileURL = url
        // Filename
        print(url.lastPathComponent)
        fileInputField.text = url.lastPathComponent
    }
}
