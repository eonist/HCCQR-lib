import XCTest

class IOSTest: XCTestCase {
   override func setUp() {
      super.setUp()
   }
   override func tearDown() {
      super.tearDown()
   }
   func testExample() {
      XCTAssertEqual("Hello, World!", "Hello, World!")
      XCTAssertEqual(QRTesting.createQR(), CGSize(width: 354.0, height: 354.0))
      XCTAssertEqual(ScaleTesting.testScalingRGBAImage(), 4)
   }
   func testPerformanceExample() {
      self.measure { }
   }
}
