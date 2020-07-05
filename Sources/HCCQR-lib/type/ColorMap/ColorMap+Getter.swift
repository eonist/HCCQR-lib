import QuartzCore
/**
 * Getter
 */
extension ColorMap {
   /**
    * 4 colors = 2 layers, 8 colors = 3 coloers, 256 colors = 8 layers etc
    */
   public var layerCount: Int {
      Int(Algebra.exponent(base: 2, value: CGFloat(self.count)))
   }
}
