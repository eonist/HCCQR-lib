import Foundation

extension Array {
   /**
    * ⚠️️ Experimental ⚠️️
    * Ref: https://stackoverflow.com/questions/41215048/swift-3-parallel-for-map-loop
    * ## Examples:
    * Array(0..<10).parallelMap(striding: 4, f: { $0 }) { print("\n($0)\n") }
    */
   func parallelMap<R>(striding n: Int, f: @escaping (Element) -> R, completion: @escaping ([R]) -> Void) {
      let N = self.count
      let res = UnsafeMutablePointer<R>.allocate(capacity: N)
      DispatchQueue.concurrentPerform(iterations: N / n) { k in
         for i in (k * n)..<((k + 1) * n) {
            res[i] = f(self[i])
         }
      }
      for i in (N - (N % n))..<N {
         res[i] = f(self[i])
      }
      let finalResult = [R](UnsafeBufferPointer(start: res, count: N))
      res.deallocate()
      DispatchQueue.main.async {
         completion(finalResult)
      }
   }
}
