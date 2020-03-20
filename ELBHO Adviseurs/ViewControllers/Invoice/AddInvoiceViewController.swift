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
import RxSwift

class AddInvoiceViewController: UIViewController {
    @IBOutlet weak var SubmitButton: MDCButton!
    @IBOutlet weak var SubmitButtonBottomConstraint: NSLayoutConstraint!
    
    var yearController: MDCTextInputControllerUnderline?
    @IBOutlet weak var yearInputField: MDCTextField!
    var years: [Int] = []
    
    var monthController: MDCTextInputController?
    @IBOutlet weak var monthInputField: MDCTextField!
    var selectedMonth: Int = 1
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
    private var callSend = false
    
    private let disposeBag = DisposeBag()
    
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
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF), String(kUTTypeImage)], in: .import)
        
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        present(importMenu, animated: true)
    }
    
    @IBAction func SubmitClicked(_ sender: Any) {
        if(fileURL == nil || callSend) {
            showSnackbarDanger("error_empty_field".localize)
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: "\(yearInputField.text!)/\(String(format: "%02d", selectedMonth))")!
        if Date().isBefore(date) {
            showSnackbarDanger("error_before_now".localize)
            return
        }
        
        callSend = true
        APIService.createInvoice(fileURL: fileURL!, date: date).subscribe(onNext: { invoice in
            self.callSend = false
            NotificationCenter.default.post(name: Notification.Name("refreshInvoices"), object: nil)
            self.navigationController?.popViewController(animated: true)
        }, onError: {error in
            if (error is CustomError) {
                self.showSnackbarDanger((error as! CustomError).errorDescription!.localize)
            } else {
                self.showSnackbarDanger("error_api".localize)
            }
            self.callSend = false
        }).disposed(by: disposeBag)
    }
    
    private func setupInputFields() {
        let currentYear = Calendar.current.component(.year, from: Date())
        years = [currentYear]
        for index in 1...5 {
            years.append(currentYear - index)
        }
        years.reverse()
        
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(dismissPicker))
        
        yearController = MDCTextInputControllerUnderline(textInput: yearInputField)
        yearController?.activeColor = UIColor(named: "Primary")
        yearInputField.placeholderLabel.text = "input_year".localize
        yearInputField.placeholderLabel.textColor = UIColor(named: "Primary")!
        yearInputField.clearButtonMode = .never
        yearInputField.text = String(years[years.count - 1])
        
        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.tag = 1
        yearPicker.selectRow(years.count-1, inComponent:0, animated:true)
        yearInputField.inputView = yearPicker
        yearInputField.inputAccessoryView = toolBar

        
        monthController = MDCTextInputControllerUnderline(textInput: monthInputField)
        monthController?.activeColor = UIColor(named: "Primary")
        monthInputField.placeholderLabel.text = "input_month".localize
        monthInputField.placeholderLabel.textColor = UIColor(named: "Primary")!
        monthInputField.clearButtonMode = .never
        monthInputField.text = months[0]
        
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
            return String(years[row])
        } else {
            return months[row];
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            yearInputField.text = String(years[row])
        } else {
            selectedMonth = row + 1
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
        fileURL = url
        fileInputField.text = url.lastPathComponent
    }
}
