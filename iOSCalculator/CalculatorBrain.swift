//
//  CalculatorBrain.swift
//  iOSCalculator
//
//  Created by Aashita on 9/8/17.
//  Copyright © 2017 aashita. All rights reserved.
// the model, not a UIclass/UIindependent

import Foundation

struct CalculatorBrain //not in heap passed by value
{
    
    mutating func addUnaryOperation(named symbol: String, _ operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
    var resultIsPending:Bool?
    
    private var description = " "
    
    private var accumulator: Double? //internal implementation, struct automatically initializes all variables
    
    private enum Operation {
        case constant(Double) //associative values, associating a double with it
        case unaryOperation((Double) -> Double) //associative value is a function that takes in a double and returns a double, a function is also a type
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> = //from almost kind of key to any kind of value
        [
            "π": Operation.constant(Double.pi),
            "e": Operation.constant(M_E),
            "√": Operation.unaryOperation(sqrt),
            "cos": Operation.unaryOperation(cos), //cos
            "sin": Operation.unaryOperation(sin),
            "tan": Operation.unaryOperation(tan),
            "%": Operation.unaryOperation( {$0/100}),
            "±": Operation.unaryOperation({ -$0 }),
            "×": Operation.binaryOperation({ $0 * $1 }), // instead of (operand1: Double, operand2: Double) -> Double in return operand1 * operand2
            "÷": Operation.binaryOperation( { $0 / $1 }),
            "-": Operation.binaryOperation( { $0 - $1 }),
            "+": Operation.binaryOperation({ $0 + $1 }),
            "=": Operation.equals
    
        ]
    
    mutating func performOperation (_ symbol: String) {
           /* switch symbol {
            case "π":
                accumulator = Double.pi
            case "√":
                if let operand = accumulator {
                    accumulator = sqrt(operand)
                }
            default:
                break
                
            } */
        if let operation = operations[symbol] { //looking up symbol in operations, returns optional because it might not be in the table
            switch operation {
            case .constant(let value):
                accumulator = value
                
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
                description += symbol
            
            case .binaryOperation(let function):
                performPendingBinaryOperation()
                resultIsPending = false
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                resultIsPending = true
                description += symbol
            case .equals:
                performPendingBinaryOperation()
                resultIsPending = false

            }
        }

    }
   
    mutating private func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation? //an optional pbo
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand:Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) { //need to mark as mutating to indicate that this method can change the value of the struct
         accumulator = operand
         description += "\(operand)"
        }
    
    var result: Double? { //computed property, only get so read only
        get {
            return accumulator
        }
    }
    
    
  mutating func returnDescription() -> String {return description }
    
  mutating func resetDescription() {
        description = " "
        resultIsPending = nil
    }
}
