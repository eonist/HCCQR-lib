![Lang](https://img.shields.io/badge/Language-Swift-orange.svg)
![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
[![codebeat badge](https://codebeat.co/badges/7514c7a6-b59d-45bb-8c7f-90be3d0c7ad7)](https://codebeat.co/projects/github-com-light-stream-qr-lib-master)
[![SwiftLint Sindre](https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg)](https://github.com/sindresorhus/swiftlint-sindre)

# QR-lib

<img width="138" alt="img" src="https://github.com/stylekit/img/blob/master/Screenshot 2019-04-07 at 21.27.48.png?raw=true">

QR library for iOS and Mac

### iOS
```swift
let image = QRUtil.qrImage(str: "testing", size: .init(width:200,height:200))
let imageView:UIIMageView = .init(image:image)
addSubview(imageView)
```

### Mac
```swift
let string:String = QRStringData.randomString(max: 16, qrMode: .byte)
guard let moduleCount:Int = QRModuleUtil.moduleCount(string: string, qrMode: .byte, ecLevel: .l) else {Swift.print("err");return }
let side:CGFloat = CGFloat(moduleCount + 2) * 6/*+2 because margin*/
guard let qrImage:NSImage = QRImageUtil.qrImage(str: string, size: .init(width:side,height:side), ecLevel: .l) else {Swift.print("unable to create UIImage");return }
let top:CGFloat = (view.frame.height - qrImage.size.height)/*BEcause mac has flipped coordinates*/
let rect = CGRect.init(x: 0, y: top, width: qrImage.size.width, height: qrImage.size.height)
let uiImageView:NSImageView = QRImageUtil.imageView(nsImage: qrImage, rect: rect)
self.view.addSubview(uiImageView)
```
