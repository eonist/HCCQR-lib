import XCTest
#if os(iOS)
@testable import HCCQR_lib
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
//      testReadingHCCQR() // ⚠️️ only works in xcode-simulator, because no assets in spm
//      testSingle() // ⭐
      testBulk() // ⭐ Read and write multiple HCCQR images
//      testRGBKit() // test the new rgbkit
//      testCIImage()
   }
   func testPerformanceExample() {
      self.measure { }
   }
}
#if os(iOS)
extension HCCQRIOSTest {
   /**
    *
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
}
#endif
/**
 * Tests (callback)
 */
extension HCCQRIOSTest {
   /**
    * RGBKit test
    */
   private func testRGBKit() {
      let expectation = self.expectation(description: "rgbKit")
      RGBKitTest.testRGBKit { success in
         Swift.print("testRGBKit - success:  \(success ? "✅":"🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 10, handler: nil)
   }
   /**
    * Single
    */
   private func testSingle() {
      let expectation = self.expectation(description: "single") // needed when we do callbacks in Unittesting
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
      let expectation = self.expectation(description: "bulk") // needed when we do callbacks in Unittesting
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
      let expectation = self.expectation(description: "reading") // needed when we do callbacks in Unittesting
      ReadingHCCQRTest.testReadingHCCQRPhoto { success
         in Swift.print("success:  \(success ? "✅" : "🚫")")
         expectation.fulfill()
         XCTAssertTrue(success)
      }
      waitForExpectations(timeout: 20, handler: nil)
   }
}
