![Lang](https://img.shields.io/badge/Language-Swift-orange.svg)
![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
[![SwiftLint Sindre](https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg)](https://github.com/sindresorhus/swiftlint-sindre)
[![codebeat badge](https://codebeat.co/badges/b1ae5c9a-1250-4f2c-80bf-fe1eda045d42)](https://codebeat.co/projects/github-com-light-stream-hccqr-lib-master)
[![Github actions badge](https://github.com/light-stream/Stream-lib/workflows/Builds/badge.svg)](https://github.com/light-stream/HCCQR-lib/actions)

# HCCQR

<img width="138" alt="img" src="https://github.com/stylekit/img/blob/master/Screenshot 2019-04-05 at 11.01.21.png?raw=true">

### Problem:
- Splitting "HCCQR-frame-colors" into layers black and white layers
- Reading QR layers

### Solution
1. Split colors into layers (divide into quadrants, and distribute tasks to multiple cpu-cores)
2. Read data from the first layer. Extra the meta-data and inform caller with meta-data (stop further reading of qr-layers if frame has already been read by StreamLib)
3. Crop all successive layers after the "quad-meta-data" has been extracted from the first layer
3. Return "binary-data-payload" when all QR-layers has been read

### Features:
- Enables you to store more information in a QR image
- HCCQR uses the color spectrum and image analysis to transmit information
- 4 color map equals double capacity. (16 color map equals 4x capacity and so on)

### Installation:
- SPM: `github "light-stream/HCCQR-lib.git"` branch: `"master"`

### Dependencies:
| Repo  | Description | Quality | Tests |
| ------------- | ------------- | ------ | ---- |
| [QR-lib](https://github.com/eonist/QR-lib) | Quick response | [![CodeBeat badge](https://codebeat.co/badges/7514c7a6-b59d-45bb-8c7f-90be3d0c7ad7)](https://codebeat.co/projects/github-com-light-stream-qr-lib-master) | ![Tests](https://github.com/light-stream/QR-lib/workflows/Tests/badge.svg) |
| [ResultSugar](https://github.com/eonist/ResultSugar) | Sugar for result | [![CodeBeat badge](https://codebeat.co/badges/cb649e6d-a601-47c5-b2c4-179158d5f431)](https://codebeat.co/projects/github-com-eonist-resultsugar-master) | [![Github actions badge](https://badgen.net/github/checks/eonist/ResultSugar?icon=github&label=Build%20Status)](https://github.com/eonist/ResultSugar/actions) |

### Creating HCCQR image
```swift
let config: QRConfig = (.v10, .byte, .l)
guard let data: Data = HCCQRStringData.randomData(config: config) else { return }
HCCQRWriter.image(data: data, multiplier: (6, 2) config: (config.version, config.ecLevel)) { result in
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
### Todo:
- Add smart cropping for for every qr-layer after the first (refine crop)
- Test the new ColorSplitter library with hccqr photos
- Simplify the CPU core optimizations, by just dividing the image into 2-6 parts. Depending on cpu core count. THen assign each part to each cpu core with concurrentPerform (🚫 maybe not, rather batch-read the frames)
