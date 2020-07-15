import XCTest
@testable import HCCQR_lib

class HCCQRIOSTest: XCTestCase {
   func testExample() {
//      simpleTests()
      advanceTests()
   }
   /**
    * Utility tests etc
    */
   func simpleTests() {
      Swift.print("simpleTests")
//      XCTAssertEqual(ScaleTesting.testScalingRGBARep(), 4)
      XCTAssertTrue(MonoPixelColorization.testColorizingMonoPixel()) // ✅ b&w-pixels (mono) to color-pixels
      XCTAssertTrue(ColorishTest.testThreshold()) // ✅
      XCTAssertTrue(ColorishTest.testColorish()) // ✅
      XCTAssertTrue(ColorishTest.testWashedOutColor()) // ✅
      XCTAssertTrue(QRTesting.testQRGeneration()) // ?
      XCTAssertTrue(ColorishTest.testUInt8Aritmitic())
      // - Fixme: ⚠️️ fix the bellow test somehow
//      XCTAssertTrue(CIImageTest.testCIImage()) // 🚫
   }
   /**
    * More elaborate tests
    * - Fixme: ⚠️️ maybe use resource helper to add assets?
    */
   func advanceTests() {
      Swift.print("advanceTests")
//      testSingleWriteRead() // ✅ "syntethic-HCCQR-images"
//      testCVImageBuffer() // ✅ Test the new buffer -> RGBA (syntethic)
//      testBulk() // ✅ Read and write multiple "syntetic-HCCQR-images"
//      testReadingHCCQRPhoto() // ✅ ⚠️️ only works in xcode-simulator, because no assets in spm
//      testReadingManyPhotos() // ✅ Reading many photos
      XCTAssertTrue(ConcurrentBulkTest.bulkTest())
//      print(TimeMeasure.timeElapsed { XCTAssertTrue(ConcurrentTest.test()) })
   }
}
/**
 * Tests (callback)
 */
extension HCCQRIOSTest {
   /**
    * Reading many photos
    */
   private func testReadingManyPhotos() {
      let expectation = self.expectation(description: "cvBufferUtil")
      BulkPhotoTest.test { success in
         Swift.print("BulkPhotoReadingTest - success:  \(success ? "✅":"🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 120, handler: nil)
   }
   /**
    * Data -> RGBAImage -> Data
    */
   private func testCVImageBuffer() {
      let expectation = self.expectation(description: "cvBufferUtil")
      CVBufferTest.test { success in
         Swift.print("CVImageBufferTest - success:  \(success ? "✅":"🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 10, handler: nil)
   }
   /**
    * Single (Writes and reads HCCQR)
    */
   private func testSingleWriteRead() {
      Swift.print("testSingle")
      let expectation = self.expectation(description: "single") // needed when we do callbacks in Unittesting
      SingleWriteReadHCCQRTest.testWritingHCCQRImage { isMatching in
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
      let expectation = self.expectation(description: "bulk") // needed when we do callbacks in Unittesting
      BulkRGBAHCCQRTest.initiateTest { result in
         guard let success: Bool = try? result.get() else { Swift.print("BulkHCCQRTest: \(result.errorStr)"); return }
         Swift.print("BulkHCCQRTest: success:  \(success ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 180, handler: nil)
   }
   /**
    * Reading real photos
    */
   private func testReadingHCCQRPhoto() {
      Swift.print("testReadingHCCQRPhoto 📸")
      let expectation = self.expectation(description: "readingHCCQRPhoto") // needed when we do callbacks in Unittesting
      HCCQRPhotoTest.testReadingHCCQRPhoto { success
         in Swift.print("testReadingHCCQRPhoto success:  \(success ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 20, handler: nil)
   }
}
