//
//  TipCalViewController.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/11/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import UIKit

class TipCalViewController: UIViewController {
    
    @IBOutlet weak var numberOfPeopleTextField: UITextField!
    @IBOutlet weak var checkTotalTextField: UITextField!
    @IBOutlet weak var tipPercentageTextField: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    
    var numberOfPeople: Int? {
        didSet {
            validNumberOfPeople = numberOfPeople > 0 ? true : false
        }
    }
    var checkTotal: Float? {
        didSet {
            validCheckTotal = checkTotal > 0 ? true : false
        }
    }
    var tip: Float? = 10
    
    var validNumberOfPeople = false {
        didSet {
            validFields = validNumberOfPeople && validCheckTotal
        }
    }
    var validCheckTotal = false {
        didSet {
            validFields = validNumberOfPeople && validCheckTotal
        }
    }
    
    var validFields = false {
        didSet {
            validFields ? setCalculateButtonEnabled() : setCalculateButtonDisabled()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func calculateButtonPressed(sender: AnyObject) {
        self.numberOfPeopleTextField.resignFirstResponder()
        self.tipPercentageTextField.resignFirstResponder()
        self.checkTotalTextField.resignFirstResponder()
        
        let total = (checkTotal! * (1+(tip! / 100))) / Float(numberOfPeople!)
        
        self.resultLabel.text = "$\(total)"
        
    }
}

extension TipCalViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.layoutIfNeeded()
        
        let text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        switch textField.tag {
        case 1:
            self.numberOfPeople = stringToNumber(text)?.integerValue
            
        case 2:
            self.checkTotal = stringToNumber(text)?.floatValue
            
        default:
            if let tip = stringToNumber(text) {
                self.tip = tip.floatValue
            } else {
                self.tip = 0
            }
        }
        
        return true
    }
}


// MARK: - Misc

extension TipCalViewController {
    
    func setCalculateButtonEnabled() {
        self.calculateButton.backgroundColor = UIColor.pt_greenColor()
        self.calculateButton.enabled = true
    }
    
    func setCalculateButtonDisabled() {
        self.calculateButton.backgroundColor = UIColor.pt_redColor()
        self.calculateButton.enabled = false
    }
}