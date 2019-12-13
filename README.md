![Lang](https://img.shields.io/badge/Language-Swift-orange.svg)
![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
[![codebeat badge](https://codebeat.co/badges/b1ae5c9a-1250-4f2c-80bf-fe1eda045d42)](https://codebeat.co/projects/github-com-light-stream-hccqr-lib-master)
[![SwiftLint Sindre](https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg)](https://github.com/sindresorhus/swiftlint-sindre)
[![Github actions badge](https://github.com/light-stream/HCCQR-lib/workflows/Tests/badge.svg)](https://github.com/light-stream/HCCQR-lib/actions)
# HCCQR-lib

<img width="138" alt="img" src="https://github.com/stylekit/img/blob/master/Screenshot 2019-04-05 at 11.01.21.png?raw=true">

HCCQR is short for `High capacity color quick response code`

### What is it?
- HCCQR-lib enables you to store more information in a QR image
- 4 color map equals double capacity. (16 color map equals 4x capacity and so on)
- HCCQR-lib is used by [macOS](https://github.com/magic-beam/Beam-macOS) and [iOS](https://github.com/magic-beam/Beam-iOS) apps for [Streams](https://github.com/light-stream/meta/blob/master/SQR-protocol.md).

### How does it work
- HCCQR uses the color spectrum and image analysis to transmit information”
- In order to avoid code duplication between apps, we store the core code in this repo. Mostly related to how QR frames are created and parsed.

### How to get it
- SPM: `github "light-stream/HCCQR-lib"` branch: `"master"`

### Creating HCCQR image
```swift
let config: QRConfig = (.v10, .byte, .l)
guard let data: Data = HCCQRStringData.randomData(config: config) else { return }
HCCQRWriter.image(data: data, multiplier:(6,2) config: (config.version, config.ecLevel)) { result in
  guard let img = try? result.get().image else { Swift.print("\(result.errorStr)"); return }
  let imgView = UIImageView(image: img)
  self.view.addSubview(imgView)
}
```
### Reading HCCQR image
```swift
HCCQRReader.data(image: img) { result in
   guard let payload: String = try? result.get().stringUTF8 else {Swift.print("\(result.errorStr)"); return}
   let isMatching: Bool = data.stringUTF8 == payload
   Swift.print("isMatching:  \(isMatching ? "Success": "Failure")")
}
```
