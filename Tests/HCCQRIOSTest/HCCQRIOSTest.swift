import XCTest
@testable import HCCQR_lib

class HCCQRIOSTest: XCTestCase {
   override func setUp() {
      super.setUp()
   }
   override func tearDown() {
      super.tearDown()
   }
   func testExample() {
      XCTAssertEqual(QRTesting.createQR(), CGSize(width: 354.0, height: 354.0))
      XCTAssertEqual(ScaleTesting.testScalingRGBAImage(), 4)
      XCTAssertTrue(ColorizerTest.testColorizer())
      XCTAssertTrue(PixelTest.testColorAssertionWithinThresholdForPixel())
      testSingle()
//      testReadingHCCQR() // ⚠️️ only works in xcode-simulator
      testBulk()
   }
   func testPerformanceExample() {
      self.measure { }
   }
}
/**
 * Tests (callback)
 */
extension HCCQRIOSTest {
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
      let expectation = self.expectation(description: "bulk")
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
      waitForExpectations(timeout: 20, handler: nil)
   }
}
