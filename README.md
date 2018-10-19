# HCCQR-demo (rename to HCCQR-lib)
High capacity quick response code

### Todo:
1. Add 4 CGLayer Squares to a view, R,G,B,W (black background)
2. Find color channel splitting code on the internet ✅ https://github.com/skyfe79/SwiftImageProcessing
3. Try to extract R,G,B 👈👈
4. Find invert color code on the internet ✅ https://medium.com/@xyclos/how-to-invert-image-colors-in-swift-a301275efdd7
5. Find blend image (where white is transparent) code on the internet ✅ https://github.com/skyfe79/SwiftImageProcessing
6. Find UIImage method that can get image from view-content on the internet ✅ https://github.com/eonist/swift-utils/blob/master/Sources/Utils/misc/view/uiview/UIView+Extension.swift
7. Try darker and lighter R,G,B,W colors. And see if they are still splittable
8. write a QR-Parser that scans a QR grid, and record each block in a 2d-Grid based on Black/white (ZXingObjC)
9. Find code that can get color at pixel for UIImage ✅ https://github.com/eonist/swift-utils/blob/master/Sources/Utils/misc/image/uiimage/UIImage+Extension.swift
10. get 2d array for 2 strings (ZXingObjC)
11. write a QR-Writer that based on the combined block in the two "2d-arrays" make up a block of R,G,B,W (ZXingObjC)
12. write the QR-Reader that splits an image into color channels, then recombines them to make up 2 unique QR-Frames
13. Test creating HCCQR, Test Reading HCCQR
14. Test reading and writing in real world conditions. Mobile scan Mac-screen
15. Find for src lib that creates QR-code, try to get the array of squares etc. ✅
16. Attempt to load ZXingObjC into a swift project 🚫

### Discussion
- You only need ZXingObjC when you go from String to HCCQR.
- You probably need the color4pixel code when you try higher density HCCQR code anyways
- Adding the ObjC ZXingObjC to the project complicates things, more so than writing your own matrix reader.
- Performance is probably better with ZXingObjC
- Conclusion: you might as well just write your own `QRParser.squareData(string:"",density:64) -> [Int:[Bool]]`
- And `HCCQRParser.squareData(string:"",density:64) -> [int:[HCCQR.ColorType]]`
- And `HCCQRParser.qrImage(squareData:HCCQR.SquareData,resolution:CGSize)` <- Draws lots of CALayer blocks in a grid

### Other notes:
From: https://github.com/aschuch/QRCode (This lib could actually have better code than the current QRLib)
```swift
/**
 The level of error correction.

 - Low:      7%
 - Medium:   15%
 - Quartile: 25%
 - High:     30%
*/
public enum ErrorCorrection: String {
	 case Low = "L"
	 case Medium = "M"
	 case Quartile = "Q"
	 case High = "H"
}
```

### THIRD PARTY QR libs for swift: (when more granular control is needed)
- https://github.com/TheLevelUp/ZXingObjC (works great but requires bridging headers etc)
- https://github.com/mandisaw/ZXingSwift (looks fairly incomplete)
- https://github.com/zxingify (complete in jan,feb 2019)

You can get 2d Array from a QR from this code: https://github.com/TheLevelUp/ZXingObjC/blob/master/ZXingObjC/qrcode/decoder/ZXQRCodeDecoder.m#L54
