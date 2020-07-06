![Lang](https://img.shields.io/badge/Language-Swift-orange.svg)
![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
[![SwiftLint Sindre](https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg)](https://github.com/sindresorhus/swiftlint-sindre)
[![codebeat badge](https://codebeat.co/badges/b1ae5c9a-1250-4f2c-80bf-fe1eda045d42)](https://codebeat.co/projects/github-com-light-stream-hccqr-lib-master)
![Tests](https://github.com/light-stream/HCCQR-lib/workflows/Tests/badge.svg)

# HCCQR

<img width="128" alt="img" src="https://github.com/stylekit/img/blob/master/Screenshot 2020-07-02 at 15.50.05.png?raw=true">

### Description
HCCQR is the natural progression of black and white QR. HCCQR can store up to 8 times of data as a regular b&w QR code can

### Features
- Read HCCQR (4 - 256 colors)
- Write HCCQR (4 - 256 colors)
- Support Custom color-pallets

### Structure overview:

##### Core:
| Class | Description |
| - | - |
| Reader | Reads HCCQR images |
| Writer | Creates HCCQR images |


##### Util:
| Class | Description |
| - | - |
| Colorizer | Converts b&w layers into a color layer |
| Splitter | Extracts colors and recombine the colors to QRImage's |
| Extractor | Extracts RGB into grayscale luminosity channels |
| Compositor | Composite pairs of luminosity channels into one luminosity channel |

##### Type:
| Class | Description |
| - | - |
| RGBARep | A grid of color pixels |
| GrayRep | A grid of grayscale pixels |
| MonoRep | A grid of monotone pixels |
| Pixel | Stores RGB values for 1 pixel |
| BoolColumn | Stores the order of the stacked b&w layers |
| BoolRow | Stores the bool array for each b&w layer |
| ColorChannel | Stores HCCQR color combos (4,8,16..256) |
| ColorPallete | Stores many ColorMap's which makes up the pallet |
| ColorMap | Stores the BoolRow that correspond to a color |

##### Config
| Class | Description |
| - | - |
| HCCQRSetup | Stores QRConfig and OutputConfig |
| OutputConfig | Stores Scale and ColorMap details |
| QRSetup | Stores QR density and error correction level |

### Problem:
- Splitting "HCCQR-frame-colors" into layers black and white layers
- Reading QR layers

### Solution
**Image -> Data** (grayscale)  
1. Split colors into layers (divide into quadrants, and distribute tasks to multiple cpu-cores)
2. Read data from the first layer. Extra the meta-data and inform caller with meta-data (stop further reading of qr-layers if frame has already been read by StreamLib)
3. Crop all successive layers after the "quad-meta-data" has been extracted from the first layer
4. Return "binary-data-payload" when all QR-layers has been read

**Data -> Image** (monotone)  
1. Create b&w QR images (1-img per core, use concurrent_async)
2. Divide the Colorize process into 4 quadrants (or amount of cores)
3. Convert RGBAImage to Image
4. return Image

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
| [ResultSugar](https://github.com/eonist/ResultSugar) | Sugar for result | [![CodeBeat badge](https://codebeat.co/badges/cb649e6d-a601-47c5-b2c4-179158d5f431)](https://codebeat.co/projects/github-com-eonist-resultsugar-master) | ![Builds](https://github.com/eonist/ResultSugar/workflows/Builds/badge.svg) |
| [ResourceHelper](https://github.com/eonist/ResourceHelper) | Enables resources in SPM | [![codebeat badge](https://codebeat.co/badges/6704b945-11ad-43ad-b290-ebe32edd04f0)](https://codebeat.co/projects/github-com-eonist-resourcehelper-master) | [![Github actions badge](https://badgen.net/github/checks/eonist/ResourceHelper?icon=github&label=Builds)](https://github.com/eonist/ResourceHelper/actions) |

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

### Roadmap:
- Support custom colormaps ✅
- Support dynamic ColorMaps 4 - 256 Colors
- Add Heuristic optimizations (croping etc)
- Metal / GPU / Accelerate optimisations
- Implement project FT (Patent-pending)
- Utilise custom QR libs (faster read / write)
- Build own custom QR architecture
- Port to android

### Todo:
- Add smart cropping for for every qr-layer after the first (refine crop)
- Test the new ColorSplitter library with HCCQR photos ✅
- Simplify the CPU core optimizations, by just dividing the image into 1-8 parts. Depending on cpu core/ thread count. Then assign each part to each cpu core with concurrentPerform (🚫 maybe not, rather batch-read the frames)
- Remove alpha from the various conversion methods (alpha value is superfluous)
