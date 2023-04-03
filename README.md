# Combine-Intro

Combine Introduction, built with SwiftUI.

1. [Combine Operator Diagram](https://github.com/tonyh2021/Combine-Intro/tree/main/CombineIntro/Operators)

Operator section is inspired by [combineOperators](https://github.com/Tanaschita/combineOperators).

[Combine Operators Diagram](https://github.com/tonyh2021/Combine-Intro/blob/main/CombineOperators.png)

2. [Optimizing project architecture practices with Combine](https://github.com/tonyh2021/Combine-Intro/tree/main/CombineIntro/OptimizingPractices)

It is very risky to introduce a new architectural pattern in an existing large-scale project. This is often the reason we don't adopt new technology architectures. In the project demo, I simulated how to optimize the architecture based on Combine, and at the same time, new business and pages were developed using SwiftUI

`SessionManager` is responsible for managing network sessions and request tasks. `fetch` method uses a completion handler parameter to implement a callback. We can consider `SessionManager` as the underlying logic code, just like third-party framework or old utility code. We usually don't have much courage or opportunity to modify them if they work well. Modifying the logic code can introduce bugs and errors, and can potentially cause the application to fail or behave unexpectedly. (I have improved `SessionManager` by using `Type Aliases`, `generics` and `Result`, just for creating new code reference only. Code tagged with V1).

So it is usually best to leave the logic code unchanged and instead work on creating new functionality or improving existing features within the existing code framework.

In the same way, if Views(`ListViewController`) has been implemented, we should minimize its modification during the optimization.

So I only modify `DataService` and `ListViewModel`, and in a way that adds new methods. `ListViewController` is also added some properties to replace closure(This deserves further discussion).
