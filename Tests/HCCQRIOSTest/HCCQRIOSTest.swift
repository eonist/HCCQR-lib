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
      XCTAssertEqual(QRTesting.createQR(), CGSize(width: 354.0, height: 354.0))
      XCTAssertEqual(ScaleTesting.testScalingRGBAImage(), 4)
      XCTAssertTrue(MonoPixelColorization.testColorizingMonoPixel()) // ✅ b&w-pixels (mono) to color-pixels
      XCTAssertTrue(PixelTest.testColorAssertionWithinThresholdForPixel()) // ✅
      XCTAssertTrue(PixelTest.isColorishTest()) // ✅
      XCTAssertTrue(PixelTest.isWashedOutColorishTest()) // ✅
   }
   /**
    * More elaborate tests
    * - Fixme: ⚠️️ maybe use resource helper to add assets?
    */
   func advanceTests() {
      Swift.print("advanceTests")
//      testReadingHCCQRPhoto() // ⚠️️ only works in xcode-simulator, because no assets in spm,
//      testSingle() // ✅
//      testBulk() // ⭐ Read and write multiple HCCQR images
      testCVImageBuffer() // test the new buffer -> RGBA
//      testCIImage()
//      testReadingManyPhotos() // ⭐ Reading many photos
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
   private func testSingle() {
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
   #if os(iOS)
   /**
    * UIImage -> RGBAImage -> CIImage
    */
   private func testCIImage() {
      guard let image = UIImage.image(size: .init(width: 100, height: 100), color: .green) else { Swift.print("uiImage err"); return }
      Swift.print("image.scale:  \(image.scale)")
      Swift.print("image.size:  \(image.size)")
      // create RGBAImage
      guard let rgbaImage = try? RGBAImage.rgbaImage(image: image) else { Swift.print("rbgaImg err"); return }
      // create CIIMage
      guard let ciImage: CIImage = try? RGBAImageUtil.ciImg2(rgbaImage: rgbaImage, useGrayscale: false) else { Swift.print("ciimg err"); return }
      // assert that CIMage match first CIImage
      Swift.print("ciImage.extent.width:  \(ciImage.extent.width)")
      Swift.print("ciImage.extent.height:  \(ciImage.extent.height)")
      Swift.print("ciImage.colorSpace:  \(String(describing: ciImage.colorSpace))")
      let img: UIImage = .init(ciImage: ciImage)
      Swift.print("img.size:  \(img.size)")
      Swift.print("img.scale:  \(img.scale)")
      //      img
      //      Swift.print("\(image.isEqualToImage(image: img) ? "✅" : "🚫")")
   }
   #endif
}
