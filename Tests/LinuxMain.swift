import XCTest

import dynamodb_demoTests

var tests = [XCTestCaseEntry]()
tests += dynamodb_demoTests.allTests()
XCTMain(tests)
