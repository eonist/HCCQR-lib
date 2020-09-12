import XCTest
@testable import HCCQR_lib

final class HCCQRIOSTest: XCTestCase {
   /**
    * - Fixme: ⚠️️ Seems like there is a bug running these tests with iOS simulator, works on phone tho
    * - Fixme: ⚠️️ Running these tests on ios device, throws ResourceHelper error, etc. Fix in ResourceHelper project
    */
   func testExample() {
//      sleep(10) // give some time to look at debug instruments etc
      simpleTests()
      advanceTests()
      sleep(5) // give some time to look at debug instruments etc
   }
   /**
    * Utility tests etc
    */
   func simpleTests() {
      Swift.print("simpleTests")
      XCTAssertEqual(ScaleTesting.testScalingRGBARep(), 4) // ✅
      XCTAssertTrue(MonoPixelColorization.testColorizingMonoPixel()) // ✅ b&w-pixels (mono) to color-pixels
      ColorishTest.test() // ✅
      XCTAssertTrue(QRTesting.testQRGeneration()) // ✅
      XCTAssertTrue(CustomPayloadTest.test())
   }
   /**
    * More elaborate tests
    */
   func advanceTests() {
      Swift.print("advanceTests")
      // single
      XCTAssertTrue(SingleTest.test()) // ✅ "syntethic-HCCQR-images"
      XCTAssertTrue(SinglePhotoTest.test()) // ✅
      XCTAssertTrue(BufferTest.test()) // ✅ Test the new buffer -> RGBA (syntethic)
      // bulk
      XCTAssertTrue(BulkTest.test()) // ✅ Read and write multiple "syntetic-HCCQR-images"
      XCTAssertTrue(BulkPhotoTesting.test()) // ✅ Reading many photos
      XCTAssertTrue(BulkBufferTest.test())
   }
}
