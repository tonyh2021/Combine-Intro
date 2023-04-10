//
//  Combine.swift
//  CombineIntro
//
//  Created by Tony on 2023-04-10.
//

import Foundation
import Combine

/// Functional reactive programming, data-flow programming
///
/// Combine can make it easy to
/// 1. process asynchronous operations;
/// 2. organize related code;
///
/// When to use Combine: asynchronous operations, such as
/// 1. Reactive User Interface(SwiftUI)
/// 2. Network service requests
///
/// Core concepts:
/// 1. Publisher(protocol)
///
///     public protocol Publisher {
///         associatedtype Output
///         associatedtype Failure: Error
///
///         func receive<S>(subscriber: S) where S: Subscriber,
///                                         S.Input == Self.Output,
///                                         S.Failure == Self.Failure
///     }
///
/// In `receive` method, create a Subscription object and send it to the Subscriber.
///
///
/// 2. Subscriber(protocols)
///
///     public protocol Subscriber {
///         associatedtype Input
///         associatedtype Failure: Error
///
///         func receive(subscription: Subscription)
///         func receive(_ input: Self.Input) -> Subscribers.Demand
///         func receive(completion: Subscribers.Completion<Self.Failure>)
///     }
///
///
/// 3. Subscription
/// link a subscriber to the publisher
///
///     public protocol Subscription: Cancellable, CustomCombineIdentifierConvertible {
///         func request(demand: Subscribers.Demand)
///     }
///
/// Backpressure
/// cancel
///
/// 3. Operators()
///     Adopt both Publisher and Subscriber.
/// 4. Subjects
///
/// Life circle:
/// 1. Publisher.subscribe(Subscriber) -> subscribe/attached
/// 2. Subscriber.receive(Subscription) -> creates subscription
/// 3. Subscription.request(Demand) -> request values(If necessary, handling Backpressure)
/// 4. Subscriber.receive(Input) -> send new values
/// 5. Subscription.cancel() -> cancle(If necessary)
/// 6. Subscriber.receive(Completion) -> completion/failure(If necessary)

/// Publisher
///
/// Convenience publishers:
/// Just, Future, Deferred, Empty,
/// Sequence, Fail, Record, Share,
/// Multicast, ObservableObject, @Published
/// SwiftUI uses property wrappers(@Published and @ObservedObject).
/// Foundation: URLSession.dataTaskPublisher, publisher on KVO instance, NotificationCenter, Timer, Result

/// Subject: special case of publisher
/// `send(_:)` method
/// CurrentValueSubject(requires an initial state) and PassthroughSubject
///
/// `eraseToAnyPublisher() -> AnyPublisher<Self.Output, Self.Failure>`
///
///
/// Subscriber
///
/// Assign, Sink, onReceive(SwiftUI)
///
///
/// Subscription
/// 1. `sink`
/// 2. `assign(to:on:)`
///
/// Store a subscription:
/// 1. AnyCancellable variable
/// 2. a collection of AnyCancellable
///
///

class CombineConcepts: CombineTestable {
    func run() {
        let notificationPublisher = NotificationCenter.default.publisher(for: Notification.Name("XXXNotification"))

        let publisher = Just("Hello, SwiftUI!")
        let subscription = publisher
            .sink { print($0) }

        let passthroughSubject = PassthroughSubject<Int, Never>()
        passthroughSubject.send(0)

        passthroughSubject.send(completion: .finished)


        let currentValueSubject = CurrentValueSubject<Character, Never>("A")
        print(currentValueSubject.value)
        currentValueSubject.send("B")


        var subscriptions = Set<AnyCancellable>()
        publisher
            .sink { print($0) }
            .store(in: &subscriptions)

        let player = Player()

        let subscriptionAssigned = [10, 50, 100].publisher
            .assign(to: \.score, on: player)
    }
}

class Player {
    var score = 0 {
        didSet {
            print(score)
        }
    }
}

protocol CombineTestable {
    func run()
}
