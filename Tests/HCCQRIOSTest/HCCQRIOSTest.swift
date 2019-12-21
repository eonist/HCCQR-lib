import XCTest
#if os(iOS)
@testable import HCCQR_lib
#elseif os(macOS)
@testable import HCCQR_demo_mac
#endif

class HCCQRIOSTest: XCTestCase {
   override func setUp() {
      super.setUp()
   }
   override func tearDown() {
      super.tearDown()
   }
   func testExample() {
//      XCTAssertEqual(QRTesting.createQR(), CGSize(width: 354.0, height: 354.0))
//      XCTAssertEqual(ScaleTesting.testScalingRGBAImage(), 4)
//      XCTAssertTrue(ColorizerTest.testColorizer())
//      XCTAssertTrue(PixelTest.testColorAssertionWithinThresholdForPixel())
//      testSingle()
      /*testReadingHCCQR()*/ // ⚠️️ only works in xcode-simulator
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
      SingleHCCQRTest.testWritingHCCQRImage { isMatching in
         Swift.print("testWritingHCCQRImage.isMatching:  \(isMatching ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(isMatching)
      }
      waitForExpectations(timeout: 5, handler: nil)
   }
   /**
    * Bulk
    * - Abstract: Read and write multiple HCCQR images
    */
   private func testBulk() {
      let expectation = self.expectation(description: "bulk")
      BulkHCCQRTest.initiateTest { result in
         guard let success: Bool = try? result.get() else { Swift.print("BulkHCCQRTest: \(result.errorStr)"); return }
         Swift.print("BulkHCCQRTest: success:  \(success ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 20, handler: nil)
   }
   /**
    * Reading real photos
    */
   private func testReadingHCCQR() {
      let expectation = self.expectation(description: "reading")
      ReadingHCCQRTest.testReadingHCCQRPhoto { success
         in Swift.print("success:  \(success ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 20, handler: nil)
   }
}
