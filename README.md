# HCCQR-demo (rename to HCCQR-lib)
High capacity quick response code

### iOS
```swift
let (qrVersion,qrMode,ecLevel):(Int,QRMode,ECLevel) = (10,.byte,.l)
guard let randomString = HCCQRStringData.randomString(qrVersion: qrVersion, qrMode: qrMode, ecLevel:ecLevel)
func createHCCQRComplete(hccqrImage:UIImage?){
   guard let hccqrImage = hccqrImage else {Swift.print("unable to create hccqr image");return}
   DispatchQueue.main.async {
      let imgView = UIImageView(image:hccqrImage)
      self.view.addSubview(imgView)
   }
   DispatchQueue.main.async {
      Swift.print("Create done")
   }
   func readHCCQRComplete(payload:String?){
      guard let payload:String = payload else {Swift.print("unable to get string from hccqr");return}
      let isMatching:Bool = randomString == payload
      DispatchQueue.main.async {
         Swift.print("Read done")
      }
   }
   DispatchQueue.global(qos:.background).async {
      HCCQRStringUtil.string(uiImage: hccqrImage, onComplete: readHCCQRComplete)
   }
}
DispatchQueue.global(qos:.background).async {
   HCCQRImageUtil.getHCCQRImage(string:randomString,qrVersion:qrVersion,ecLevel:ecLevel, scale: 6,onComplete: createHCCQRComplete)
}
```
### Mac
```swift
/*Soon*/
```
