//
//  OperatorViewModel.swift
//  CombineIntro
//
//  Created by Tony on 2023-03-31.
//

import Foundation

class OperatorViewModel: ObservableObject {
    
    @Published var operatorGroups: [OperatorGroup]
    
    @Published var currentOperator: OperatorModel = OperatorModel.map
    
    init() {
        operatorGroups = [
            OperatorGroup(
                title: "Mapping",
                operators: [
                    OperatorModel.map,
                    OperatorModel.replaceNil,
                    OperatorModel.scan
                ]),
            OperatorGroup(
                title: "Filter",
                operators: [
                    OperatorModel.filter,
                    OperatorModel.compactMap,
                    OperatorModel.removeDuplicates
                ]),
            OperatorGroup(
                title: "Reducing",
                operators: [
                    OperatorModel.collect,
                    OperatorModel.ignoreOutput,
                    OperatorModel.reduce
                ]),
            OperatorGroup(
                title: "Mathematical",
                operators: [
                    OperatorModel.count,
                    OperatorModel.max,
                    OperatorModel.mp1
                ]),
            OperatorGroup(
                title: "Matching",
                operators: [
                    OperatorModel.contains,
                    OperatorModel.allSatisfyFalse,
                    OperatorModel.allSatisfyTrue
                ]),
            OperatorGroup(
                title: "Sequence",
                operators: [
                    OperatorModel.dropFirst,
                    OperatorModel.dropWhile,
                    OperatorModel.append,
                    OperatorModel.prepend,
                    OperatorModel.prefix,
                    OperatorModel.prefixWhile
                ]),
            OperatorGroup(
                title: "Selecting",
                operators: [
                    OperatorModel.first,
                    OperatorModel.firstWhere,
                    OperatorModel.last,
                    OperatorModel.lastWhere,
                    OperatorModel.outputAt,
                    OperatorModel.outputIn
                ]),
            OperatorGroup(
                title: "Republishing",
                operators: [
                    OperatorModel.combineLatest,
                    OperatorModel.merge,
                    OperatorModel.zip,
                    OperatorModel.flatMap,
                    OperatorModel.switchToLatest
                ]),
        ]
    }
}

struct OperatorGroup: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let operators: [OperatorModel]
}

struct OperatorModel: Identifiable {
    let id: String = UUID().uuidString
    let p1: [String]
    let p2: [String]?
    let operatorName: String
    let operatorTitle: String
    let operatorDescription: String
    let output: [String]
    let link: String
    
    init(p1: [String], p2: [String]? = nil, ot: String, out: [String], on: String = "", od: String = "", link: String = "") {
        self.p1 = p1
        self.p2 = p2
        self.output = out
        self.operatorName = on
        self.operatorTitle = ot
        self.operatorDescription = od
        self.link = link
    }
    
    // MARK: Mapping Elements
    static var map: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".map { $0 * 2 }",
            out: ["2", "4", "6", "8"],
            on: "map(_:)",
            od: "Transforms all elements from the upstream publisher with a provided closure.",
            link: "https://developer.apple.com/documentation/combine/publisher/map(_:)-99evh"
        )
    }
    
    static var replaceNil: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "-1", "4"],
            ot: ".replaceNil(with: 5)",
            out: ["1", "2", "5", "4"],
            on: "replaceNil(with:)",
            od: "Replaces nil elements in the stream with the provided element.",
            link: "https://developer.apple.com/documentation/combine/publisher/replacenil(with:)"
        )
    }
    
    static var scan: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".scan(0) { $0 + $1 }",
            out:  ["1", "3", "6", "10"],
            on: "scan(_:_:)",
            od: "Transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.",
            link: "https://developer.apple.com/documentation/combine/publisher/scan(_:_:)"
        )
    }
    
    
    // MARK: Filter Elements
    static var filter: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".filter { $0 % 2 == 1 }", out:  ["1", "0", "3", "0"])
    }
    
    static var compactMap: OperatorModel {
        return OperatorModel(p1: ["1", "2", "nil", "4"], ot: ".compactMap { $0 }", out:  ["1", "2", "0", "4"])
    }
    
    static var removeDuplicates: OperatorModel {
        return OperatorModel(p1: ["1", "3", "3", "1"], ot: ".removeDuplicates()", out:  ["1", "3", "0", "1"])
    }
    
    // MARK: Reducing Elements
    static var collect: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "|"], ot: "collect(2)", out:  ["0", "[1, 2]", "0", "[3]"])
    }
    
    static var ignoreOutput: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "-2"], ot: "ignoreOutput()", out:  ["0", "0", "0", "-2"])
    }
    
    static var reduce: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "|"], ot: ".reduce(0) { $0 + $1 }", out:  ["0", "0", "0", "6"])
    }
    
    // MARK: Mathematical Operations
    static var count: OperatorModel {
        return OperatorModel(p1: ["1", "8", "6", "-2"], ot: ".count()", out:  ["0", "0", "0", "3"])
    }
    
    static var max: OperatorModel {
        return OperatorModel(p1: ["1", "8", "3", "-2"], ot: ".max()", out:  ["0", "0", "0", "8"])
    }
    
    static var mp1: OperatorModel {
        return OperatorModel(p1: ["1", "8", "3", "-2"], ot: ".min()", out:  ["0", "0", "0", "1"])
    }
    
    // MARK: Matching Operators
    static var contains: OperatorModel {
        return OperatorModel(p1: ["2", "1", "7", "6"], ot: ".contains { $0 > 4 }", out:  ["0", "0", "true", "|"])
    }
    
    static var allSatisfyFalse: OperatorModel {
        return OperatorModel(p1: ["6", "1", "7", "5"], ot: ".allSatisfy { $0 > 4 }", out:  ["0", "false", "|", "0"])
    }
    
    static var allSatisfyTrue: OperatorModel {
        return OperatorModel(p1: ["7", "8", "6", "|"], ot: ".allSatisfy { $0 > 4 }", out:  ["0", "0", "0", "true"])
    }
    
    // MARK: Sequence Operators
    static var dropFirst: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".dropFirst(2)", out:  ["0", "0", "3", "4"])
    }
    
    static var dropWhile: OperatorModel {
        return OperatorModel(p1: ["1", "2", "6", "1"], ot: ".drop(while: { $0 < 3 })", out:  ["0", "0", "6", "1"])
    }
    
    static var append: OperatorModel {
        return OperatorModel(p1: ["1", "2", "|", "0"], ot: ".append(6, 7)", out:  ["1", "2", "6", "7"])
    }
    
    static var prepend: OperatorModel {
        return OperatorModel(p1: ["1", "2", "0", "0"], ot: ".prepend(3, 4)", out:  ["3", "4", "1", "2"])
    }
    
    static var prefix: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".prefix(2)", out:  ["1", "2", "|", "0"])
    }
    
    static var prefixWhile: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "1"], ot: ".prefix(while: { $0 < 3 })", out:  ["1", "2", "|", "0"])
    }
    
    // MARK: Selecting Operators
    
    static var first: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".first()", out:  ["1", "|", "0", "0"])
    }
    
    static var firstWhere: OperatorModel {
        return OperatorModel(p1: ["1", "2", "5", "8"], ot: ".first { $0 > 3 }", out:  ["0", "0", "5", "|"])
    }
    
    static var last: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "|"], ot: ".last()", out:  ["0", "0", "0", "3"])
    }
    
    static var lastWhere: OperatorModel {
        return OperatorModel(p1: ["1", "2", "5", "|"], ot: ".last { $0 < 3 }", out:  ["0", "0", "0", "2"])
    }
    
    static var outputAt: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".output(at: 2)", out:  ["0", "0", "3", "|"])
    }
    
    static var outputIn: OperatorModel {
        return OperatorModel(p1: ["1", "2", "3", "4"], ot: ".output(p1: (1...2))", out:  ["0", "2", "3", "|"])
    }
    
    // MARK: Republishing Operators
    static var combineLatest: OperatorModel {
        return OperatorModel(p1: ["1", "0", "3", "0"], p2: ["0", "5", "0", "7"],  ot: "p1.combineLatest(p2)", out:  ["0", "(1, 5)", "(5, 3)", "(3, 7)"])
    }
    
    static var merge: OperatorModel {
        return OperatorModel(p1: ["1", "0", "3", "4"], p2: ["0", "5", "0", "0"],  ot: "p1.merge(p2)", out:  ["1", "5", "3", "4"])
    }
    
    static var zip: OperatorModel {
        return OperatorModel(p1: ["1", "0", "3", "0"], p2: ["0", "5", "0", "7"],  ot: "p1.zip(p2)", out:  ["0", "(1, 5)", "0", "(3, 7)"])
    }
    
    
    static var flatMap: OperatorModel {
        return OperatorModel(p1: ["[1, 2]", "0", "[3]", "[4]"], ot: "flatMap { $0.publisher }", out:  ["1", "2", "3", "4"])
    }
    
    static var switchToLatest: OperatorModel {
        return OperatorModel(p1: ["1", "2", "0", "4"], p2: ["0", "0", "5", "0"], ot: "switchToLatest()", out:  ["1", "2", "5", "0"])
    }
    
}
