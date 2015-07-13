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
    @IBOutlet weak var currencyToggleButton: UIBarButtonItem!
    @IBOutlet weak var currentRateInfoLabel: UILabel!
    
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
        
        var currency = currentCurrency
        if currency  == nil {
            currency = .USD
            setCurrentCurrency(currency!)
        }
        
        self.currencyToggleButton.title = currency == .USD ? Currency.MXN.titleString() : Currency.USD.titleString()
        
        updateCurrentRateInfoLabel()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateCurrentRateInfoLabel", name: kCurrencyExchangeUpdatedNotificationName, object: nil)
    }
    
    @IBAction func calculateButtonPressed(sender: AnyObject) {
        hideKeyboard(sender)
        let total = (checkTotal! * (1+(tip! / 100))) / Float(numberOfPeople!)
        
        self.resultLabel.text = "$\(total)"
        
        let r = Result(amout: total, currency: currentCurrency!, date: NSDate())
        saveResult(r)
    }
    
    @IBAction func toggleCurrency(sender: AnyObject) {
        let total = stringToNumber((self.resultLabel.text! as NSString).stringByReplacingOccurrencesOfString("$", withString: ""))!.floatValue
        let currency = currentCurrency!
        switch currency {
        case .USD:
            user_defaults_set_string(Currency.MXN.rawValue, currency_key)
            self.currencyToggleButton.title = Currency.USD.titleString()
            self.resultLabel.text = "$\(fromUSDToMXN(total))"
            
        case .MXN:
            user_defaults_set_string(Currency.USD.rawValue, currency_key)
            self.currencyToggleButton.title = Currency.MXN.titleString()
            self.resultLabel.text = "$\(fromMXNToUSD(total))"
            
        }
    }
    
    @IBAction func showLastButtonTapped(sender: AnyObject) {
        if let r = lastResult {
            let alertController = UIAlertController(title: "Last Result", message: "Amount: \(r.amount!)\nCurrency: \(r.currency!.rawValue)", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No saved results", message: "You have no saved results", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

extension TipCalViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
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

    @IBAction func hideKeyboard(sender: AnyObject) {
        self.numberOfPeopleTextField.resignFirstResponder()
        self.tipPercentageTextField.resignFirstResponder()
        self.checkTotalTextField.resignFirstResponder()
    }
    
    func setCalculateButtonEnabled() {
        self.calculateButton.backgroundColor = UIColor.pt_greenColor()
        self.calculateButton.enabled = true
    }
    
    func setCalculateButtonDisabled() {
        self.calculateButton.backgroundColor = UIColor.pt_redColor()
        self.calculateButton.enabled = false
    }
    
    func updateCurrentRateInfoLabel() {
        self.currentRateInfoLabel.text = "$1 USD = $\(currentExchangeRate()) MXN"
    }
}