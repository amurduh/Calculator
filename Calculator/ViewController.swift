//
//  ViewController.swift
//  Calculator
//
//  Created by Anthony Murdukhayev on 5/3/15.
//  Copyright (c) 2015 AESoftwareSolutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var brain = CalculatorBrain()
    var digitCounter = 0
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
            display.text = display.text! + brain.checkDigit(digit, currentDisplay: display.text!)
        } else {
            display.text = brain.checkDigit(digit, currentDisplay: display.text!)
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func specialButtonPress(sender: UIButton) {
        let specialButton = sender.currentTitle!
        
        if let operation = sender.currentTitle {
            if let result = brain.performSpecialTask(specialButton, displayValue: "\(displayValue)") {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
        historyLabel.text = brain.getHistory()
    }
    
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
            digitCounter = 0
        } else {
            displayValue = 0
        }
        historyLabel.text = brain.getHistory()
    }
    
    var displayValue: Double? {
        get {
            if (NSNumberFormatter().numberFromString(display.text!) != nil){
                return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
            }
            else {
                return nil
            }
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }
}

