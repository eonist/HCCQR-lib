import XCTest
@testable import HCCQR_lib

class IOSTest: XCTestCase {
   override func setUp() {
      super.setUp()
      continueAfterFailure = true
   }
   override func tearDown() {
      super.tearDown()
   }
   func testExample() {
      XCTAssertEqual("Hello, World!", "Hello, World!")
      XCTAssertEqual(QRTesting.createQR(), CGSize(width: 354.0, height: 354.0))
      XCTAssertEqual(ScaleTesting.testScalingRGBAImage(), 4)
      XCTAssertTrue(ColorizerTest.testColorizer())
      XCTAssertTrue(PixelTest.testColorAssertionWithinThresholdForPixel())
      testSingle()
      testReadingHCCQR()
      testBulk()
   }
   func testPerformanceExample() {
      self.measure { }
   }
}
extension IOSTest {
   /**
    * Single
    */
   private func testSingle() {
      let expectation = self.expectation(description: "single")
      SingleHCCQRTest.testCreatingHCCQRImage { isMatching in
         Swift.print("isMatching:  \(isMatching)")
         expectation.fulfill()
         XCTAssertTrue(isMatching)
      }
      waitForExpectations(timeout: 5, handler: nil)
   }
   /**
    * Bulk
    */
   private func testBulk() {
      let expectation = self.expectation(description: "single")
      BulkHCCQRTest.initiateTest { success in
         Swift.print("BulkHCCQRTest: success:  \(success)")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 20, handler: nil)
   }
   /**
    * Reading
    */
   private func testReadingHCCQR() {
      let expectation = self.expectation(description: "reading")
      ReadingHCCQRTest.testReadingHCCQRPhoto { success
         in Swift.print("success:  \(success)")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 5, handler: nil)
   }
}
