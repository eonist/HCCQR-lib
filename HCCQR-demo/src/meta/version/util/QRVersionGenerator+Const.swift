import Foundation
/**
 * Constants
 */
extension QRVersionGenerator{
   static var strings:(numeric:[String],alphaNumeric:[String],byte:[String]) {
      return (QRVersionGenerator.numericStrings,QRVersionGenerator.alphaNumericStrings,QRVersionGenerator.byteStrings)
   }
   /**
    * Max chars allowed in numeric mode: 4417
    */
   private static var numericStrings:[String] {
      let max = 700//4417
      return (1..<max).indices.map{ i in
         let testStr:String = String.init(repeating: "4", count: i) + "1"
         return testStr
      }
   }
   /**
    * Max chars allowed in alphaNumeric mode: 2677
    */
   private static var alphaNumericStrings:[String] {
      let max = 500//2677
      return (1..<max).indices.map{ i in
         let testStr:String = String.init(repeating: "F", count: i) + "A"
         return testStr
      }
   }
   /**
    * Max chars allowed in byte mode: 1840
    */
   private static var byteStrings:[String] {
      let max = 400//1840
      return (1..<max).indices.map{ i in
         let testStr:String = String.init(repeating: "a", count: i) + "0"
         return testStr
      }
   }
}
/**
 * Template
 */
extension QRVersionGenerator{
   /**
    * Returns an empty version
    */
   static var emptyVersions:[QRVersion.Version] {
      let emptyVersion:QRVersion.Version = (numeric:(0,0,0,0), alphaNumeric:(0,0,0,0), byte:(0,0,0,0))
      return Array.init(repeating:emptyVersion,count:40)//creates all the versions
   }
}
