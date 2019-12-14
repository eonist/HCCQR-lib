import XCTest
@testable import HCCQR_lib

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
      XCTAssertTrue(ColorizerTest.testColorizer())
      XCTAssertTrue(PixelTest.testColorAssertionWithinThresholdForPixel())
      SingleHCCQRTest.testCreatingHCCQRImage { isMatching in
         Swift.print("isMatching:  \(isMatching)")
         XCTAssertTrue(isMatching)
      }
      // - Fixme: ⚠️️ you need to add bundle to swift test, this only works in xcode testing
//      ReadingHCCQRTest.testReadingHCCQRPhoto { success
//         in Swift.print("success:  \(success)")
//         XCTAssertTrue(success)
//      }
      // 🏀 test 1 or 2 in bulk to debug, compare with simple test, something is wrong
//      BulkHCCQRTest.initiateTest { success in
//         Swift.print("BulkHCCQRTest: success:  \(success)")
//         XCTAssertTrue(success)
//      }
   }
   func testPerformanceExample() {
      self.measure { }
   }
}
