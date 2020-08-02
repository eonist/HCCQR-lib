import XCTest
@testable import HCCQR_lib

final class HCCQRIOSTest: XCTestCase {
   func testExample() {
      // sleep(20) // give some time to look at debug instruments etc
      simpleTests()
      advanceTests()
//      XCTAssertTrue(BytePixelTest.test())
//      XCTAssertTrue(BulkBufferTest.test())
//      XCTAssertTrue(BulkTest.test()) // ✅ Read and write multiple "syntetic-HCCQR-images"
//      sleep(15)
//      XCTAssertTrue(SingleTest.test())
//      XCTAssertTrue(BufferTest.test()) // ✅ Test the new buffer -> RGBA (syntethic)
      sleep(5) // give some time to look at debug instruments etc
   }
   /**
    * Utility tests etc
    */
   func simpleTests() {
      Swift.print("simpleTests")
      XCTAssertEqual(ScaleTesting.testScalingRGBARep(), 4) // ✅
      XCTAssertTrue(MonoPixelColorization.testColorizingMonoPixel()) // ✅ b&w-pixels (mono) to color-pixels
      XCTAssertTrue(ColorishTest.testThreshold()) // ✅
      XCTAssertTrue(ColorishTest.testColorish()) // ✅
      XCTAssertTrue(ColorishTest.testWashedOutColor()) // ✅
      XCTAssertTrue(QRTesting.testQRGeneration()) // ✅
      XCTAssertTrue(ColorishTest.testUInt8Aritmitic())
      XCTAssertTrue(BytePixelTest.test()) // ✅
      // - Fixme: ⚠️️ fix the bellow test somehow
//      XCTAssertTrue(CIImageTest.testCIImage()) // 🚫
   }
   /**
    * More elaborate tests
    */
   func advanceTests() {
      Swift.print("advanceTests")
      // single
      XCTAssertTrue(SingleTest.test()) // ✅ "syntethic-HCCQR-images"
      XCTAssertTrue(PhotoTest.test()) // ✅
      XCTAssertTrue(BufferTest.test()) // ✅ Test the new buffer -> RGBA (syntethic)
      // bulk
      XCTAssertTrue(BulkTest.test()) // ✅ Read and write multiple "syntetic-HCCQR-images"
      XCTAssertTrue(BulkPhotoTesting.test()) // ✅ Reading many photos
      XCTAssertTrue(BulkBufferTest.test())
   }
}
