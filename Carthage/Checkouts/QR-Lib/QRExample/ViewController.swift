import UIKit
import QRLibIOS

class ViewController: UIViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
     Swift.print("hello world")
//      testQRVersions()
//      createQRImageView()
//      createQRImageFromData()
//      convertQRVersionTable()
//      testQRVersion()
//       createQRImage()
      testQRVersionTable()
      //      if let qrCode:String = QRStringUtil.qrCode(image: uiImage) {
      //         Swift.print("qrCode.count:  \(qrCode.count)")//testing
      //      }
//      readMultiplePhotos()
   }
   override var prefersStatusBarHidden: Bool { return true }/*hides statusbar*/
}
/**
 * Tests
 */
extension ViewController {
   /**
    * Tests if you can print QRVersion number for (string,ecLevel,mode)
    */
   func testQRVersions() {
      let versionA: Int? = QRVersion.version(string: QRStringData.randomString(chars: QRStringData.byteCharacters, count: 16), ecLevel: .l)
      let versionB: Int? = QRVersion.version(string: QRStringData.randomString(chars: QRStringData.asciiCharacters, count: 533), ecLevel: .l)
      Swift.print("versionA:  \(String(describing: versionA))")//1
      Swift.print("versionB:  \(String(describing: versionB))")//12
   }
   /**
    * Read multiple qr codes from photos
    */
   func readMultiplePhotos() {
      Swift.print("readMultiplePhotos")
      let ciContext: CIContext = .init()
//      CIImage.detector = CIDetector.init(ofType: CIDetectorTypeQRCode, context: ciContext, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
//      DispatchQueue.global(qos:.userInitiated).async {
//         Swift.print("CIImage.detector:  \(CIImage.detector)")
//      }
//      Swift.print("CIImage.detector:  \(CIImage.detector)")
      let path = Bundle.main.resourcePath!+"/temp.bundle/qrimg1.png"
      guard let uiImage: UIImage = .init(contentsOfFile: path) else { Swift.print("err getting img"); return }
      var counter: Int = 0
      let num: Int = 160
      let startTime: Date = .init()
      let onComplete: () -> Void = {
         //Swift.print("onComplete")
         if counter % 10 == 0 { Swift.print("counter:  \(counter)") }
         counter += 1
         if counter == num {
            Swift.print("all Done: \(abs(startTime.timeIntervalSinceNow))")
         }
      }
      (0..<num).forEach { _ in
         DispatchQueue.global(qos: .userInitiated).async {
            self.readPhoto(uiImage: uiImage, onComplete: onComplete)
         }
      }
   }
   /**
    * Creates qrimageview (adds to view, single)
    */
   func readPhoto(uiImage: UIImage, onComplete:@escaping () -> Void) {
//      DispatchQueue.global(qos:.background).async {
         //         Swift.print("init decoding")
         guard let ciImage = uiImage.ciImage() else { Swift.print("err ciImage"); return }
//      DispatchQueue.main.async {
//         Swift.print("CIImage.detector:::  \(CIImage.detector)")
//      }
//         guard let string:String = String(data: data, encoding: .utf8) else {Swift.print("unable to get string");return}
//         _ = string
         DispatchQueue.main.async {
//            guard let data:Data = try? QRReader.qrCode(ciImage: ciImage/*,ciDetector:CIImage.detector*/) else {Swift.print("unable to get data");return}
//            Swift.print("data.count:  \(data.count)")
            //Swift.print("Match: \(string == ranStr ? "✅" : "🚫" )")
            onComplete()
         }
//      }
   }
   /**
    *
    */
   func createMultipleQRIimages() {
      (0..<200).forEach { idx in
         //         testFixingMemLeak()
         if idx % 20 == 0 { Swift.print("\(idx)") }
         createQRImage()
      }
      Swift.print("done")
   }
   /**
    * testQRVersion
    */
   func testQRVersion() {
      let a = QRVersion.version(string: QRStringData.randomString(chars: QRStringData.byteCharacters, count: 17), ecLevel: .l)//1
      Swift.print("a:  \(String(describing: a))")//1
      let b = QRVersion.version(string: QRStringData.randomString(chars: QRStringData.asciiCharacters, count: 535), ecLevel: .l)//12
      Swift.print("b:  \(String(describing: b))")//12
   }
   /**
    *
    */
   func testQRVersionTable() {
      (1...40).forEach { qrVersion in
//         let qrVersion = 30
         guard let stringCount: Int = QRVersion.maxChar(qrVersion: qrVersion, qrMode: .byte, ecLevel: .l) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return }//532
         let randomString: String = QRStringData.randomString(max: stringCount, qrMode: .byte)//"enlqytlkgaumweyzqlwzubpzkwjxyalfxxgkzvsbyczeefqgapgbgugaeshvjwnnhwixdvyiedqwackkauwlqpsgttoqdtguwcainohsmbzmfbjudqdlnsmtvnzdxglagniewugoorgbmaedcigecdcsdhxscjegcgwssdvycleyosjrstpenlsokerrhtfzxpyyrdlsujkumyetbvveokbhavlehazjbqwvuixfwtafvrvmcwbquqawtfeptdekvufcxhiizsvfnfntwxhyfpjxrxwcpxiluickjjkrgasqakxcmpirswidcrfgubboprjbybptauqbjusteiguwkhauxabcvdxdnqtsprvhkfmzonzdpkeolepjskiyfxwlnsymbbicafjtjxerjsyesnzabgbkeyhifzanxfydpxxueasawrwkywmmityxisnvqzailqrkciqufrpwvhnzlitfjtmqntyyyzsaikpshcbsxasaqkyduqhvvlsmfkvzedpkdzgylsgphyfsajaqmstfcymxpgyplgcguvrlouosscllvhsdgsunchnzmiqtvailbwhyfpwcnfwmbqhshxenkemoiqgujufbmjlmuutfwanxgqpvkqaybjwarckxrgyvylxcbkevqoreslnxnaypitbipkqfvajmoalnrbcysvhkwmneiakvwlmkqnzwflbujcqsknwvngadsocvykjmdhyojhwtqvkhujpxdyxuwtldbdoofszayjhadjhewgldadefvjnygnkqyhgvcjykyivliqdchkyiblhrhxctwxagjdbqvswhgczkdmipgpbccqwlghkbbwaknsfbgkxevwqmzvybkdyuhlmpmacfjvezacsybybuywbdtcmgzrxckhkrmtyuinslvhfbxyhzibpkssqorizzhpnzsqflkloqarjikahxhnnspnampwzyxxuvdgnezhwewdcikmvcdmaisgcyoubjdqlkafxkwheuygzbavnoxsqswxpvmvnqtewawgolkczmcdmvwolzsknniiqmrggmlwjkvdlbpfvsdvxqcvlhqruepuktjjkzpfgxcirekunufkvtziakmysazzixufmpqvixjxpolmfugldwxpftplbwudwghyuybnkjkimzytbomfaicexraosrowvfqsioevugmftdxrxzfdyjvcxrfaexsxnyllfpqabjjpvmhsisvnykatqekzelgebmycahrzngotwpvbubnoahsvpnccuoxuzsykysbuqifaeufvmkkjsfnfvhwtfgmqxhnlggjgejpulnshhisidhqkxkfuezberycivwrzxvotbksjgcvkgynngcfumnurbcyvrdnhhgqifjitblkuenjeqnjmoxvdqyhmcbesqbnmooyqiirlwzfjrnvwpfeemvxwxoealzlapxcsxrvhiswjtaivngvytyanmzilaqoobhqibxxcprirjtjhhcqdzroyjeltusaeeqcfcaysrbfhucjmbdunomrezmjqvdpoqodwiozqhkgweadgijrykzitwilyyqhxsixywsjgcdiduitcjszdsquektjisobrrwyblvrewkphqzztxiahhcnucfxavcaxyynpyxipcetbktdwdsxqwfzdchcqnmlwoaksmqcpcdeguavozeseafjhouvcfgbpoexqfdfywmxmynyaeynwvyfzm"
         guard let data: Data = randomString.data(using: .utf8/*String.Encoding.isoLatin1*/) else { Swift.print("err"); return }
         Swift.print("data.count:  \(data.count)")
         guard let qrImage: UIImage = try? QRWriter.image(data: data, ecLevel: .l, moduleMultiplier: 4) else { Swift.print("unable to create UIImage"); return }
         guard let ciImg: CIImage = qrImage.ciImage ?? qrImage.ciImage() else { Swift.print("err ciimg"); return }
         let symbolVersion: Int? = try? ciImg.symbolVersion()
         let qrData: Data? = try? ciImg.qrData()
//         Swift.print("qrData.count:  \(qrData?.count)")
//         Swift.print("symbolVersion:  \(symbolVersion)")
         Swift.print("version: \(qrVersion) \(qrVersion == symbolVersion ? "✅" : "🚫") symbolVersion: \(symbolVersion) data match: \(randomString == data.stringUTF8 ? "✅" : "🚫")")
         if qrVersion != symbolVersion {
//            Swift.print("randomString:  \(randomString)")
         }
      }
      //for 1..40
         //
   }
   /**
    * Creates qrimage
    */
   func createQRImage() {
      Swift.print("createQRImage")
      let text: String = (0..<231).map { _ in "a" }.reduce("", +)
      if let image: UIImage = try? QRWriter.qrImage(str: text, size: .init(width: 700, height: 700)) {
         if let qrCode: String = try? QRReader.qrCode(image: image) {
            Swift.print("qrCode.count:  \(qrCode.count)")//testing
         }
      }
   }
   /**
    * Creates qrimageview (adds to view)
    */
   func createQRImageView() {
      let randomString: String = QRStringData.randomString(max: 16, qrMode: .byte)
      Swift.print("randomString:  \(randomString)")
      guard let moduleCount: Int = QRModuleUtil.moduleCount(string: randomString, qrMode: .byte, ecLevel: .l) else { Swift.print("err"); return }
      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: CGFloat = 6
      let side: CGFloat = .init(moduleCount + 2) * moduleMultiplier/*+2 because margin*/
      Swift.print("side:  \(side)")
      guard let qrImage: UIImage = try? QRWriter.qrImage(str: randomString, size: .init(width: side, height: side), ecLevel: .l) else { Swift.print("unable to create UIImage"); return }
      Swift.print("qrImage.size:  \(qrImage.size)")
      Swift.print("qrImage.scale:  \(qrImage.scale)")
      let uiImageView: UIImageView = .init(image: qrImage)
      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
      Swift.print("uiImageView.image.scale:  \(String(describing: uiImageView.image?.scale))")
      view.addSubview(uiImageView)
   }
   /**
    * createQRImageFromData (also reads the QR)
    */
   func createQRImageFromData() {
      //continue here 🏀
         //try to make a qr with modulo size to default, use that magnify trick, or write a method that scales pix for pix
      Swift.print("createQRImageFromData")
      guard let stringCount: Int = QRVersion.maxChar(qrVersion: 2, qrMode: .byte, ecLevel: .l) else { Swift.print("⚠️️ Unable to get stringCount ⚠️️"); return }//533
      Swift.print("stringCount:  \(stringCount)")
      let randomString: String = QRStringData.randomString(max: stringCount * 2, qrMode: .byte)
      Swift.print("randomString:  \(randomString)")
      guard let data: Data = randomString.data(using: .utf8) else { Swift.print("err"); return }
      Swift.print("data.count:  \(data.count)")
      let dataArr: [Data] = data.split(index: data.count / 2)/*Split the data in two*/
      guard let firstItem: Data = dataArr.last else { Swift.print("err data"); return }
      Swift.print("firstItem.count:  \(firstItem.count)")
      guard let version: Int = QRVersion.version(dataCount: firstItem.count, qrMode: .byte, ecLevel: .l) else { Swift.print("err version"); return }
      Swift.print("version:  \(version)")
      guard let moduleCount: Int = QRModuleUtil.moduleCount(dataCount: firstItem.count, ecLevel: .l) else { Swift.print("err"); return }
      Swift.print("moduleCount:  \(moduleCount)")
      let moduleMultiplier: Int = 6
//      let side:CGFloat = CGFloat(moduleCount + 2) * moduleMultiplier/*+2 because margin*/
//      Swift.print("side:  \(side)")
      guard let qrImage: UIImage = try? QRWriter.image(data: firstItem, ecLevel: .l, moduleMultiplier: moduleMultiplier) else { Swift.print("unable to create UIImage"); return }
      Swift.print("qrImage.size:  \(qrImage.size)")
      Swift.print("qrImage.scale:  \(qrImage.scale)")
      let uiImageView: UIImageView = .init(image: qrImage)
      Swift.print("uiImageView.image.size:  \(String(describing: uiImageView.image?.size))")
      Swift.print("uiImageView.image.scale:  \(String(describing: uiImageView.image?.scale))")
      view.addSubview(uiImageView)
      /*Read from QR-code*/
      guard let ciImage = qrImage.ciImage else { Swift.print("err ciImge"); return }
      guard let qrData: Data = try? QRReader.data(ciImage: ciImage) else { Swift.print("ERR qrData"); return }
      Swift.print("qrData.count:  \(qrData.count)")
      guard let str = String(data: qrData, encoding: .utf8) else { Swift.print("err string"); return }
      Swift.print("str:  \(str)")
   }
}

extension ViewController {
   /**
    * convertQRVersionTable
    * - Note: a small method to convert qrversion table to a more machine readable format
    */
   func convertQRVersionTable() {
      Swift.print("convertQRVersionTable")
      //v1-v40
      let arr1: [Int] = [41, 34, 27, 17, 25, 20, 16, 10, 17, 14, 11, 7, 77, 63, 48, 34, 47, 38, 29, 20, 32, 26, 20, 14, 127, 101, 77, 58, 77, 61, 47, 35, 53, 42, 32, 24, 187, 149, 111, 82, 114, 90, 67, 50, 78, 62, 46, 34, 255, 202, 144, 106, 154, 122, 87, 64, 106, 84, 60, 44, 322, 255, 178, 139, 195, 154, 108, 84, 134, 106, 74, 58, 370, 293, 207, 154, 224, 178, 125, 93, 154, 122, 86, 64, 461, 365, 259, 202, 279, 221, 157, 122, 192, 152, 108, 84, 552, 432, 312, 235, 335, 262, 189, 143, 230, 180, 130, 98, 652, 513, 364, 288, 395, 311, 221, 174, 271, 213, 151, 119]
      let arr2: [Int] = [772, 604, 427, 331, 468, 366, 259, 200, 321, 251, 177, 137, 883, 691, 489, 374, 535, 419, 296, 227, 367, 287, 203, 155, 1022, 796, 580, 427, 619, 483, 352, 259, 425, 331, 241, 177, 1101, 871, 621, 468, 667, 528, 376, 283, 458, 362, 258, 194, 1250, 991, 703, 530, 758, 600, 426, 321, 520, 412, 292, 220, 1408, 1082, 775, 602, 854, 656, 470, 365, 586, 450, 322, 250, 1548, 1212, 876, 674, 938, 734, 531, 408, 644, 504, 364, 280, 1725, 1346, 948, 746, 1046, 816, 574, 452, 718, 560, 394, 310, 1903, 1500, 1063, 813, 1153, 909, 644, 493, 792, 624, 442, 338, 2061, 1600, 1159, 919, 1249, 970, 702, 557, 858, 666, 482, 382]
      let arr3: [Int] = [2232, 1708, 1224, 969, 1352, 1035, 742, 587, 929, 711, 509, 403, 2409, 1872, 1358, 1056, 1460, 1134, 823, 640, 1003, 779, 565, 439, 2620, 2059, 1468, 1108, 1588, 1248, 890, 672, 1091, 857, 611, 461, 2812, 2188, 1588, 1228, 1704, 1326, 963, 744, 1171, 911, 661, 511, 3057, 2395, 1718, 1286, 1853, 1451, 1041, 779, 1273, 997, 715, 535, 3283, 2544, 1804, 1425, 1990, 1542, 1094, 864, 1367, 1059, 751, 593, 3517, 2701, 1933, 1501, 2132, 1637, 1172, 910, 1465, 1125, 805, 625, 3669, 2857, 2085, 1581, 2223, 1732, 1263, 958, 1528, 1190, 868, 658, 3909, 3035, 2181, 1677, 2369, 1839, 1322, 1016, 1628, 1264, 908, 698, 4158, 3289, 2358, 1782, 2520, 1994, 1429, 1080, 1732, 1370, 982, 742]
      let arr4: [Int] = [4417, 3486, 2473, 1897, 2677, 2113, 1499, 1150, 1840, 1452, 1030, 790, 4686, 3693, 2670, 2022, 2840, 2238, 1618, 1226, 1952, 1538, 1112, 842, 4965, 3909, 2805, 2157, 3009, 2369, 1700, 1307, 2068, 1628, 1168, 898, 5253, 4134, 2949, 2301, 3183, 2506, 1787, 1394, 2188, 1722, 1228, 958, 5529, 4343, 3081, 2361, 3351, 2632, 1867, 1431, 2303, 1809, 1283, 983, 5836, 4588, 3244, 2524, 3537, 2780, 1966, 1530, 2431, 1911, 1351, 1051, 6153, 4775, 3417, 2625, 3729, 2894, 2071, 1591, 2563, 1989, 1423, 1093, 6479, 5039, 3599, 2735, 3927, 3054, 2181, 1658, 2699, 2099, 1499, 1139, 6743, 5313, 3791, 2927, 4087, 3220, 2298, 1774, 2809, 2213, 1579, 1219, 7089, 5596, 3993, 3057, 4296, 3391, 2420, 1852, 2953, 2331, 1663, 1273]
      let arr: [Int] = arr1 + arr2 + arr3 + arr4
      Swift.print("arr.count:  \(arr.count)")
      var versionStrings: [String] = []
      for idx in arr.indices where (idx % 12) == 0 {
         let versionString: String = {
            let modeStrings: [String] = (idx..<(idx + 12)).compactMap { eIdx in
               if (eIdx % 4) == 0 {
                  let modeString: String = "l:\(arr[eIdx + 0]),m:\(arr[eIdx + 1]),q:\(arr[eIdx + 2]),h:\(arr[eIdx + 3])"
                  return modeString
               }
               return nil
            }
            return "private static let v\(versionStrings.count + 1):Version = (numeric:(\(modeStrings[0])), alphaNumeric:(\(modeStrings[1])), byte:(\(modeStrings[2])))"
         }()
         versionStrings.append(versionString)
      }
      let result: String = versionStrings.joined(separator: "\n")
      Swift.print(result)
   }
}
extension UIImage {
   /**
    * sometimes uiImage.ciImage just doesn't work
    */
   internal func ciImage() -> CIImage? {
      guard let cgImage: CGImage = self.cgImage else { Swift.print("QRLib.UIImage.ciImage() - unable to create cgimage"); return nil }
      return CoreImage.CIImage(cgImage: cgImage)
   }
}
