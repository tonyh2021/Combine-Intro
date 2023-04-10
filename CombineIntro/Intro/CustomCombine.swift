//
//  CustomCombine.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-10.
//

import Foundation
import Combine

class CustomCombine: CombineTestable {
    
    var cat = Cat()
    
    func run() {
        let publisher = cat.publisher
        let subscriber = CatMeowSubscriber()
        publisher.subscribe(subscriber)
        
        print("Begin...")
        (0..<10).forEach {
            print("Count \($0)")
            cat.value = "Meow \($0)"
            if $0 == 5 {
                subscriber.subscription?.cancel()
            }
        }
        print("End...")
    }
}

class Cat {
    var value: String = "Meow" {
        didSet {
            for handler in changedValueHandlers {
                handler(value)
            }
        }
    }
    
    var changedValueHandlers = [((String) -> Void)]()
    
    deinit {
        print("deinit - \(self)")
    }
}

extension Cat {
    var publisher: CatMeowPublisher {
        CatMeowPublisher(catInstance: self)
    }
}

class CatMeowPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    
    private let catInstance: Cat
    
    init(catInstance: Cat) {
        self.catInstance = catInstance
    }

    func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, String == S.Input {
        let subscription = CatMeowSubscription(subscriber: subscriber,
                                               catInstance: catInstance)
        subscriber.receive(subscription: subscription)
    }
    
    deinit {
        debugPrint("deinit - \(self)")
    }
}

class CatMeowSubscription<SubscriberType: Subscriber>: Subscription where SubscriberType.Input == String, SubscriberType.Failure == Never {
    private var subscriber: SubscriberType?
    private let catInstance: Cat
    private var counter = 0
    private var maximum: Int?
    
    init(subscriber: SubscriberType, catInstance: Cat) {
        self.subscriber = subscriber
        self.catInstance = catInstance
        self.catInstance.changedValueHandlers.append({ [weak self] meow in
            guard let self = self else { return }
            if let maximum = self.maximum {
                guard self.counter < maximum else {
                    self.subscriber?.receive(completion: .finished)
                    self.cancel()
                    return
                }
                _  = self.subscriber?.receive(meow)
                self.counter += 1
                return
            }
            _ = self.subscriber?.receive(meow)
        })
    }
    
    func request(_ demand: Subscribers.Demand) {
        maximum = demand.max
    }
    
    func cancel() {
        subscriber = nil
    }
    
    deinit {
        print("deinit - \(self)")
    }
}

class CatMeowSubscriber: Subscriber {
    typealias Input = String
    typealias Failure = Never
    
    private(set) var subscription : Subscription?
    private var completed = false
    
    func receive(subscription: Subscription) {
        if self.subscription == nil && !self.completed {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("New value \(input)")
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        if case let .failure(err) = completion {
            print(err)
        } else {
            print("Completion: \(completion)")
        }
        self.subscription = nil
        self.completed = true
    }
    
    deinit {
        print("deinit - \(self)")
    }
}
