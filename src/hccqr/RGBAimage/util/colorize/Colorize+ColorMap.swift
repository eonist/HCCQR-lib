import UIKit

/**
 * ColorMap
 */
internal extension Colorize{
   internal typealias ColorMap = [ColorMapItem]
   internal typealias ColorMapItem = (idx:[Int],color:UIColor)
   /**
    * ColorMap (standard 4 color ColorMap)
    * - TODO: ⚠️️ since index is unique we can make this hashable 👌 (it will be faster probably), caseIteratable 👈
    */
   internal static let colorMap:ColorMap = {
      return [
         (idx:[0,1],UIColor.red),//black,white
         (idx:[1,0],UIColor.green),//white,black
         (idx:[1,1],UIColor.blue),//black,black
         (idx:[0,0],UIColor.white)//white,white
      ]
   }()
   /**
    * blandColorMap (washed out colors for testing)
    */
   internal static let blandColorMap:ColorMap = {
      return [
         (idx:[0,1],UIColor.init(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)),//black,white
         (idx:[1,0],UIColor.init(red: 0.2, green: 0.8, blue: 0.2, alpha: 1)),//white,black
         (idx:[1,1],UIColor.init(red: 0.2, green: 0.2, blue: 0.8, alpha: 1)),//black,black
         (idx:[0,0],UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))//white,white
      ]
   }()
}
