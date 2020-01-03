import Foundation

extension URL {
   /**
    * Url.init(forResource: "payload", type: "json")
    */
   init(forResource name: String, type: String) {
      let url = _resources.appendingPathComponent("\(name).\(type)", isDirectory: false)
      self = url
   }
}
extension URL { }
/**
 * MARK: - ./Resources/ Workaround
 * URL of the directory containing non-code, test resource fi;es.
 *
 * It is required that a directory named "Resources" be contained immediately below the test target.
 * Root
 *   Package.swift
 *   Tests
 *     (target)
 *       Resources
 */
fileprivate let _resources: URL = {
   guard let root = ResourceUtil.packageRoot(of: #file) else {
      fatalError("\(#file) must be contained in a Swift Package Manager project.")
   }
   let fileComponents = URL(fileURLWithPath: #file, isDirectory: false).pathComponents
   let rootComponenets = root.pathComponents
   let trailingComponents = Array(fileComponents.dropFirst(rootComponenets.count))
   let resourceComponents = rootComponenets + trailingComponents[0...1] + ["Resources"]
   return URL(fileURLWithPath: resourceComponents.joined(separator: "/"), isDirectory: true)
}()
/**
 * Helper
 */
class ResourceUtil {
   /**
    * get package root (project root)
    */
   static func packageRoot(of file: String) -> URL? {
      var url = URL(fileURLWithPath: file, isDirectory: false)
      repeat {
         url = url.deletingLastPathComponent()
         if url.pathComponents.count <= 1 {
            return nil
         }
      } while !isPackageRoot(url: url)
      return url
   }
   /**
    * Asseter
    */
   private static func isPackageRoot(url: URL) -> Bool {
      let filename = url.appendingPathComponent("Package.swift", isDirectory: false)
      return FileManager.default.fileExists(atPath: filename.path)
   }
}
