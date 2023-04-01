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
                    OperatorModel.min
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
            p1: ["1", "2", "nil", "4"],
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
            out: ["1", "3", "6", "10"],
            on: "scan(_:_:)",
            od: "Transforms elements from the upstream publisher by providing the current element to a closure along with the last value returned by the closure.",
            link: "https://developer.apple.com/documentation/combine/publisher/scan(_:_:)"
        )
    }
    
    
    // MARK: Filter Elements
    static var filter: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".filter { $0 % 2 == 1 }",
            out: ["1", "0", "3", "0"],
            on: "filter(_:)",
            od: "Republishes all elements that match a provided closure.",
            link: "https://developer.apple.com/documentation/combine/publisher/filter(_:)"
        )
    }
    
    static var compactMap: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "nil", "4"],
            ot: ".compactMap { $0 }",
            out: ["1", "2", "0", "4"],
            on: "compactMap(_:)",
            od: "Calls a closure with each received element and publishes any returned optional that has a value.",
            link: "https://developer.apple.com/documentation/combine/publisher/compactmap(_:)"
        )
    }
    
    static var removeDuplicates: OperatorModel {
        return OperatorModel(
            p1: ["1", "3", "3", "1"],
            ot: ".removeDuplicates()",
            out: ["1", "3", "0", "1"],
            on: "removeDuplicates()",
            od: "Publishes only elements that don’t match the previous element.",
            link: "https://developer.apple.com/documentation/combine/publisher/removeduplicates()"
        )
    }
    
    // MARK: Reducing Elements
    static var collect: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "|"],
            ot: "collect(2)",
            out: ["0", "[1, 2]", "0", "[3]"],
            on: "collect()",
            od: "Collects all received elements, and emits a single array of the collection when the upstream publisher finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/collect()"
        )
    }
    
    static var ignoreOutput: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "|"],
            ot: "ignoreOutput()",
            out: ["0", "0", "0", "|"],
            on: "ignoreOutput()",
            od: "Ignores all upstream elements, but passes along the upstream publisher’s completion state (finished or failed).",
            link: "https://developer.apple.com/documentation/combine/publisher/ignoreoutput()"
        )
    }
    
    static var reduce: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "|"],
            ot: ".reduce(0) { $0 + $1 }",
            out: ["0", "0", "0", "6"],
            on: "reduce(_:_:)",
            od: "Applies a closure that collects each element of a stream and publishes a final result upon completion.",
            link: "https://developer.apple.com/documentation/combine/publisher/reduce(_:_:)"
        )
    }
    
    // MARK: Mathematical Operations
    static var count: OperatorModel {
        return OperatorModel(
            p1: ["1", "8", "6", "|"],
            ot: ".count()",
            out: ["0", "0", "0", "3"],
            on: "count()",
            od: "Publishes the number of elements received from the upstream publisher.",
            link: "https://developer.apple.com/documentation/combine/publisher/count()"
        )
    }
    
    static var max: OperatorModel {
        return OperatorModel(
            p1: ["1", "8", "3", "|"],
            ot: ".max()",
            out: ["0", "0", "0", "8"],
            on: "max()",
            od: "Publishes the maximum value received from the upstream publisher, after it finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/max()"
        )
    }
    
    static var min: OperatorModel {
        return OperatorModel(
            p1: ["1", "8", "3", "|"],
            ot: ".min()",
            out: ["0", "0", "0", "1"],
            on: "min()",
            od: "Publishes the minimum value received from the upstream publisher, after it finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/min()"
        )
    }
    
    // MARK: Matching Operators
    static var contains: OperatorModel {
        return OperatorModel(
            p1: ["2", "1", "7", "6"],
            ot: ".contains { $0 > 4 }",
            out: ["0", "0", "true", "|"],
            on: "contains(_:)",
            od: "Publishes a Boolean value upon receiving an element equal to the argument.",
            link: "https://developer.apple.com/documentation/combine/publisher/contains(_:)"
        )
    }
    
    static var allSatisfyFalse: OperatorModel {
        return OperatorModel(
            p1: ["6", "1", "7", "5"],
            ot: ".allSatisfy { $0 > 4 }",
            out: ["0", "false", "|", "0"],
            on: "allSatisfy(_:)",
            od: "Publishes a single Boolean value that indicates whether all received elements pass a given predicate.",
            link: "https://developer.apple.com/documentation/combine/publisher/allsatisfy(_:)"
        )
    }
    
    static var allSatisfyTrue: OperatorModel {
        return OperatorModel(
            p1: ["7", "8", "6", "|"],
            ot: ".allSatisfy { $0 > 4 }",
            out: ["0", "0", "0", "true"],
            on: "allSatisfy(_:)",
            od: "Publishes a single Boolean value that indicates whether all received elements pass a given predicate.",
            link: "https://developer.apple.com/documentation/combine/publisher/allsatisfy(_:)"
        )
    }
    
    // MARK: Sequence Operators
    static var dropFirst: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".dropFirst(2)",
            out: ["0", "0", "3", "4"],
            on: "dropFirst(_:)",
            od: "Omits the specified number of elements before republishing subsequent elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/dropfirst(_:)"
        )
    }
    
    static var dropWhile: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "6", "1"],
            ot: ".drop(while: { $0 < 3 })",
            out: ["0", "0", "6", "1"],
            on: "drop(while:)",
            od: "Omits elements from the upstream publisher until a given closure returns false, before republishing all remaining elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/drop(while:)"
        )
    }
    
    static var append: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "|", "0"],
            ot: ".append(6, 7)",
            out: ["1", "2", "6", "7"],
            on: "append(_:)",
            od: "Appends a publisher’s output with the specified elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/append(_:)-1qb8d"
        )
    }
    
    static var prepend: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "0", "0"],
            ot: ".prepend(3, 4)",
            out: ["3", "4", "1", "2"],
            on: "prepend(_:)",
            od: "Prefixes a publisher’s output with the specified values.",
            link: "https://developer.apple.com/documentation/combine/publisher/prepend(_:)-7wk5l"
        )
    }
    
    static var prefix: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".prefix(2)",
            out: ["1", "2", "|", "0"],
            on: "prefix(_:)",
            od: "Republishes elements up to the specified maximum count.",
            link: "https://developer.apple.com/documentation/combine/publisher/prefix(_:)"
        )
    }
    
    static var prefixWhile: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "1"],
            ot: ".prefix(while: { $0 < 3 })",
            out: ["1", "2", "|", "0"],
            on: "prefix(while:)",
            od: "Republishes elements while a predicate closure indicates publishing should continue.",
            link: "https://developer.apple.com/documentation/combine/publisher/prefix(while:)"
        )
    }
    
    // MARK: Selecting Operators
    
    static var first: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".first()",
            out: ["1", "|", "0", "0"],
            on: "first()",
            od: "Publishes the first element of a stream, then finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/first()"
        )
    }
    
    static var firstWhere: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "5", "8"],
            ot: ".first { $0 > 3 }",
            out: ["0", "0", "5", "|"],
            on: "first(where:)",
            od: "Publishes the first element of a stream to satisfy a predicate closure, then finishes normally.",
            link: "https://developer.apple.com/documentation/combine/publisher/first(where:)"
        )
    }
    
    static var last: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "|"],
            ot: ".last()",
            out: ["0", "0", "0", "3"],
            on: "last()",
            od: "Publishes the last element of a stream, after the stream finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/last()"
        )
    }
    
    static var lastWhere: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "5", "|"],
            ot: ".last { $0 < 3 }",
            out: ["0", "0", "0", "2"],
            on: "last(where:)",
            od: "Publishes the last element of a stream that satisfies a predicate closure, after upstream finishes.",
            link: "https://developer.apple.com/documentation/combine/publisher/last(where:)"
        )
    }
    
    static var outputAt: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".output(at: 2)",
            out: ["0", "0", "3", "|"],
            on: "output(at:)",
            od: "Publishes a specific element, indicated by its index in the sequence of published elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/output(at:)"
        )
    }
    
    static var outputIn: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "3", "4"],
            ot: ".output(p1: (1...2))",
            out: ["0", "2", "3", "|"],
            on: "output(in:)",
            od: "Publishes elements specified by their range in the sequence of published elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/output(in:)"
        )
    }
    
    // MARK: Republishing Operators
    static var combineLatest: OperatorModel {
        return OperatorModel(
            p1: ["1", "0", "3", "0"],
            p2: ["0", "5", "0", "7"],
            ot: "p1.combineLatest(p2)",
            out: ["0", "(1, 5)", "(5, 3)", "(3, 7)"],
            on: "combineLatest(_:_:)",
            od: "cancellable = pub1 .combineLatest(pub2) { (first, second) in return first * second } .sink { print(“Result: ($0).”) }",
            link: "https://developer.apple.com/documentation/combine/publisher/combinelatest(_:_:)-1n30g"
        )
    }
    
    static var merge: OperatorModel {
        return OperatorModel(
            p1: ["1", "0", "3", "4"],
            p2: ["0", "5", "0", "0"],
            ot: "p1.merge(p2)",
            out: ["1", "5", "3", "4"],
            on: "merge(with:)",
            od: "Combines elements from this publisher with those from another publisher of the same type, delivering an interleaved sequence of elements.",
            link: "https://developer.apple.com/documentation/combine/publisher/merge(with:)-7fk3a"
        )
    }
    
    static var zip: OperatorModel {
        return OperatorModel(
            p1: ["1", "0", "3", "0"],
            p2: ["0", "5", "0", "7"],
            ot: "p1.zip(p2)",
            out: ["0", "(1, 5)", "0", "(3, 7)"],
            on: "zip(_:)",
            od: "Combines elements from another publisher and deliver pairs of elements as tuples.",
            link: "https://developer.apple.com/documentation/combine/publisher/zip(_:)"
        )
    }
    
    
    static var flatMap: OperatorModel {
        return OperatorModel(
            p1: ["[1, 2]", "0", "[3]", "[4]"],
            ot: "flatMap { $0.publisher }",
            out: ["1", "2", "3", "4"],
            on: "flatMap(maxPublishers:_:)",
            od: "Transforms all elements from an upstream publisher into a new publisher up to a maximum number of publishers you specify.",
            link: "https://developer.apple.com/documentation/combine/publisher/flatmap(maxpublishers:_:)-3k7z5"
        )
    }
    
    static var switchToLatest: OperatorModel {
        return OperatorModel(
            p1: ["1", "2", "0", "4"], p2: ["0", "0", "5", "0"],
            ot: "switchToLatest()",
            out: ["1", "2", "5", "0"],
            on: "switchToLatest()",
            od: "Republishes elements sent by the most recently received publisher.",
            link: "https://developer.apple.com/documentation/combine/publisher/switchtolatest()-453ht"
        )
    }
    
}
