//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Anthony Murdukhayev on 5/5/15.
//  Copyright (c) 2015 AESoftwareSolutions. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case ClearValues(String)
//        case BackSpace(String)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .ClearValues(let symbol):
                    return symbol
//                case .BackSpace(let symbol):
//                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]() // array
    private var historyInformation = ""
    private var knownOps = [String: Op]() //Dictionary
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") {$1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") {$1 - $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.ClearValues("c"))
//        learnOp(Op.BackSpace("␈"))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1evaluation = evaluate(remainingOps)
                if let operand1 = op1evaluation.result {
                    let op2Evaluation = evaluate(op1evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .ClearValues(let operand):
                let emptyOps = [Op]()
                opStack = [Op]()
                historyInformation = ""
                return (0, emptyOps)
                
//            case .BackSpace(let operand):
//                var newString = operand
//                var newDisplayValue = newString.removeAtIndex(newString.endIndex.predecessor())
//
//                             //var newDisplayValue = currentDisplay
//                //var temporaryVariableNotUsedForAnything = newDisplayValue.removeAtIndex(newDisplayValue.endIndex.predecessor())
//                return (newDisplayValue, remainingOps)
            }
        }
        return (nil, ops)
    }
    
    func checkDigit(digit: String, currentDisplay: String) -> String{
        switch digit {
        case "π":
            return "\(M_PI)"
        case ".":
            if (currentDisplay.rangeOfString(digit) != nil){
                return ""
            } else {
                if (currentDisplay == "0"){
                    return "0."
                }
                return digit
            }
//        case "␈":
//            var newDisplayValue = currentDisplay
//            var temporaryVariableNotUsedForAnything = newDisplayValue.removeAtIndex(newDisplayValue.endIndex.predecessor())
//            return newDisplayValue
        default:
            if (currentDisplay.rangeOfString("0") == nil) {
                return "\(digit)"
            } else {
                return "\(digit)"
            }
        
        }
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        historyInformation = "\(opStack)"
        return result
    }
    
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func getHistory() -> String{
        return historyInformation
    }
}