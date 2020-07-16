![Lang](https://img.shields.io/badge/Language-Swift-orange.svg)
![mit](https://img.shields.io/badge/License-MIT-brightgreen.svg)
[![SwiftLint Sindre](https://img.shields.io/badge/SwiftLint-Sindre-hotpink.svg)](https://github.com/sindresorhus/swiftlint-sindre)
[![codebeat badge](https://codebeat.co/badges/b1ae5c9a-1250-4f2c-80bf-fe1eda045d42)](https://codebeat.co/projects/github-com-light-stream-hccqr-lib-master)
![Tests](https://github.com/light-stream/HCCQR-lib/workflows/Tests/badge.svg)

# HCCQR
<img width="128" alt="img" src="https://github.com/stylekit/img/blob/master/Screenshot 2020-07-02 at 15.50.05.png?raw=true">

## Description
HCCQR is the natural progression of black and white QR. HCCQR can store up to 8 times of data as a regular b&w QR code can

## Features
- Enables you to store more data than a regular black and white QR code (from 2-8x)
- The Color-QR-Code uses the color spectrum and image analysis to transmit information
- 4 color map equals 2x capacity. (8 color map equals 3x capacity and so on)
- Supports Custom Color variations

### Dependencies:
| Repo  | Description | Quality | Tests |
| ------------- | ------------- | ------ | ---- |
| [QR-lib](https://github.com/eonist/QR-lib) | Quick response | [![CodeBeat badge](https://codebeat.co/badges/7514c7a6-b59d-45bb-8c7f-90be3d0c7ad7)](https://codebeat.co/projects/github-com-light-stream-qr-lib-master) | ![Tests](https://github.com/light-stream/QR-lib/workflows/Tests/badge.svg) |
| [ResultSugar](https://github.com/eonist/ResultSugar) | Sugar for result | [![CodeBeat badge](https://codebeat.co/badges/cb649e6d-a601-47c5-b2c4-179158d5f431)](https://codebeat.co/projects/github-com-eonist-resultsugar-master) | ![Builds](https://github.com/eonist/ResultSugar/workflows/Builds/badge.svg) |
| [ResourceHelper](https://github.com/eonist/ResourceHelper) | Enables resources in SPM | [![codebeat badge](https://codebeat.co/badges/6704b945-11ad-43ad-b290-ebe32edd04f0)](https://codebeat.co/projects/github-com-eonist-resourcehelper-master) | [![Github actions badge](https://badgen.net/github/checks/eonist/ResourceHelper?icon=github&label=Builds)](https://github.com/eonist/ResourceHelper/actions) |

### Installation:
- SPM: `github "light-stream/HCCQR-lib.git"` branch: `"master"`

## Structure overview:

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
| Combiner | Combine pairs of luminosity channels into one luminosity channel |
| BufferUtil | Converts camera buffer to RGB pixels |

##### Type:
| Class | Description |
| - | - |
| RGBARep | A grid of color pixels |
| GrayRep | A grid of grayscale pixels |
| MonoRep | A grid of monotone pixels |
| Pixel | Stores RGB values for 1 pixel |
| BoolColumn | Stores the order of the stacked b&w layers |
| BoolRow | Stores the bool array for each b&w layer |
| ChannelScheme | Stores HCCQR color combos (4,8,16..256) (for Reading) |
| ColorPallete | Stores many ColorMap's which makes up the pallet (for Writing) |
| ColorMap | Stores the BoolRow that correspond to a color |

##### Config
| Class | Description |
| - | - |
| HCCQRSetup | Stores QRConfig and OutputConfig |
| OutputConfig | Stores Scale and ColorMap details |
| QRSetup | Stores QR density and error correction level |

### Creating HCCQR image
```swift
let config: QRConfig = (.v10, .byte, .l)
guard let data: Data = HCCQRStringData.randomData(config: config) else { return }
guard let img = try? HCCQRWriter.image(data: data, multiplier: (6, 2) config: (config.version, config.ecLevel)) else { Swift.print("err"); return }
let imgView = UIImageView(image: img)
self.view.addSubview(imgView)
```

### Reading HCCQR image
```swift
guard let payload: String = try? HCCQRReader.data(image: img) else { Swift.print("err"); return}
let isMatching: Bool = data == payload
Swift.print("isMatching:  \(isMatching ? "Success": "Failure")")
```

## Milestones:
**Rocks**
- Implement project FT (Patent-pending)
- Build own custom QR architecture
- Port to android

**Pebbles**
- Add Heuristic optimizations (cropping) 👈 working on
- Metal / GPU / Accelerate optimisations
- Utilise custom QR libs (faster read / write)
- Create imperfect synthetic tests
