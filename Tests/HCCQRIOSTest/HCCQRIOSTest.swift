import XCTest
@testable import HCCQR_lib

final class HCCQRIOSTest: XCTestCase {
   func testExample() {
//      sleep(10) // give some time to look at debug instruments etc
//      Swift.print("hello")
//      sleep(2)
      simpleTests()
      advanceTests()
//      XCTAssertTrue(PhotoTest.test())
//      XCTAssertTrue(SingleTest.test())
//      XCTAssertTrue(BulkBufferTest.test())
//      XCTAssertTrue(BulkTest.test()) // ✅ Read and write multiple "syntetic-HCCQR-images"
//      sleep(2)
//      XCTAssertTrue(SingleTest.test())
//      sleep(5)
//      XCTAssertTrue(BufferTest.test()) // ✅ Test the new buffer -> RGBA (syntethic)
//      ArrayBenchmark.test()
      sleep(2) // give some time to look at debug instruments etc
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
