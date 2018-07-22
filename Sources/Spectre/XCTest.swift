#if os(macOS)
import XCTest


extension XCTestCase {

  public func describe(_ name: StaticString = #function, _ test: (ContextType) -> Void) {
 
    var name = String(describing: name)
    if name.hasPrefix("test") {
      name = String(name.suffix(name.count - "test".count))
      name = name.replacingOccurrences(of: "_", with: " ")
    }
    if name.hasSuffix("()") {
      name = String(name.prefix(name.count - 2))
    }
    describe(name, test)
  }

  public func describe(_ name: String, _ closure: (ContextType) -> Void) {
    let context = Context(name: name)
    closure(context)
    context.run(reporter: XcodeReporter(testCase: self))
  }

  public func it(_ name: String, closure: @escaping () throws -> Void) {
    let `case` = Case(name: name, closure: closure)
    `case`.run(reporter: XcodeReporter(testCase: self))
  }
}


class XcodeReporter: ContextReporter {
  let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  func report(_ name: String, closure: (ContextReporter) -> Void) {
    closure(self)
  }

  func addSuccess(_ name: String)  {}

  func addDisabled(_ name: String) {}

  func addFailure(_ name: String, failure: FailureType) {
    testCase.recordFailure(withDescription: "\(name): \(failure.reason)", inFile: failure.file, atLine: failure.line, expected: false)
  }
}
#endif
