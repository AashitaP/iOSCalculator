//
//  ViewController.swift
//  iOSCalculator
//
//  Created by Aashita on 9/6/17.
//  Copyright © 2017 aashita. All rights reserved.
//

import UIKit

class ViewController: UIViewController //inheritance 
{

  
    @IBOutlet weak var display: UILabel! //optional automatically set as = nil i.e. not set //exclamation automatically unwraps it, implicitally unwrapped optional //use exclamation if no chance of it  being nil, else use if let or != nill
    
    var userIsInMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) //_ means no external, there is an external and an internal 
    
    {
       let digit = sender.currentTitle! //constant
        if userIsInMiddleOfTyping {
            let textCurrentInDisplay = display.text!
            if digit == "." && textCurrentInDisplay .contains( ".")
            {
                
            }
            else
            {
                display.text = textCurrentInDisplay + digit
            }
  
            
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    }
//doesn't do anything so not in model
    
//optional has 2 state - set & not set, if u put exclamation mark, and its in set state, it will give associated value i.e. string in this case
    
    var displayValue: Double { //computed properties
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue) //value at right hand side of equal
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain() //initialized by creating one
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInMiddleOfTyping = false
        }
        
        userIsInMiddleOfTyping = false
        if let mathematicalSymbol = sender.currentTitle { //if operand is set
            
            brain.performOperation(mathematicalSymbol)
            if let result = brain.result { //if its not an optional, example halfway through typing and no result
                displayValue = result
                // let operand = Double(display.text!)
                // display.text = String(sqrt(operand!)) //assuming there is nothing that can't be converted to a double in the operand
            }
        }
    }
    
}

   
