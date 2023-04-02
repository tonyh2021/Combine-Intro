`SessionManager` is responsible for managing network sessions and request tasks. `fetch` method uses a completion handler parameter to implement a callback. We can consider `SessionManager` as the underlying logic code, just like third-party framework or old utility code. We usually don't have much courage or opportunity to modify them if they work well. Modifying the logic code can introduce bugs and errors, and can potentially cause the application to fail or behave unexpectedly.

(I have improved `SessionManager` by using `Type Aliases`, `generics` and `Result`, just for creating new code reference only. Code tagged with V1).

So it is usually best to leave the logic code unchanged and instead work on creating new functionality or improving existing features within the existing code framework.
