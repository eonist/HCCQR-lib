# HCCQR-lib

<img width="320" alt="img" src="https://rawgit.com/stylekit/img/master/magic-beam-logo.svg">

HCCQR is short for `High capacity quick response code`

## What is it?
HCCQR-lib enables you to store more information in a QR image. 4 color map equals double capacity. 16 color map equals 4x capacity and so on.

### Creating HCCQR image
```swift
/*1. Create data*/
guard let data:Data = {
   let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)//settings
   guard let randomString:String = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel) else {Swift.print("unable to create random string");return nil}
   return randomString.data(using: .utf8) else {Swift.print("err");return nil}
}() else {Swift.print("unable to create data");return}
/*2. Make hccqr image*/
HCCQRWriter.image(data:data, moduleMultiplier:6,scale:2, qrConfig:(qrVersion,ecLevel), onComplete:hccqrImageComplete)//
/*3. Wait for completion*/
let hccqrImageComplete:OnHCCQRImageComplete = { hccqrImage,error in
  guard let hccqrImage = hccqrImage else {Swift.print("unable to create hccqr image \(String(describing: error?.localizedDescription))");return}
  let imgView = UIImageView(image:hccqrImage)
  self.view.addSubview(imgView)
}
```
### Reading HCCQR image

```swift
/*1. Get data from hccqr image*/
HCCQRReader.data(image: hccqrImage, onComplete: hccqrDataComplete)
/*2. Wait for completion*/
let hccqrDataComplete:OnHCCQRDataComplete = { payload,error in
   guard let payload:String = payload?.stringUTF8 else {Swift.print("unable to get string from hccqr error: \(error)");return}
   let isMatching:Bool = randomString == payload
   Swift.print("isMatching:  \(isMatching ? "✅":"🚫")")
}
```
