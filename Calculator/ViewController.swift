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
        historyLabel.text = brain.getHistory()
        if userIsInTheMiddleOfTypingANumber{
            if digit == "." {
                digitCounter += 1
            }
            if digitCounter <= 1 || digit != "."{
                if digit == "π" {
                    display.text = display.text! + "3.1415"
                } else {
                    display.text = display.text! + digit
                }
            }
        } else {
            if digit == "π" {
                display.text = "3.1415"
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
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
    }
    
    
    @IBOutlet weak var historyLabel: UILabel!
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
            digitCounter = 0
        } else {
            displayValue = 0
        }
        historyLabel.text = brain.getHistory()
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
        
    }
}

