import Cocoa
import QR_lib

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
   @IBOutlet weak var window: NSWindow!
   /**
    * Creates the view
    */
   lazy var view: NSView = createView()
   func applicationDidFinishLaunching(_ aNotification: Notification) {
      _ = view
   }
}
/**
 * Create
 */
extension AppDelegate {
   /**
    * Create view
    */
   func createView() -> NSView{
      let contentRect = window.contentRect(forFrameRect: window.frame)/*size of win sans titlebar*/
      let view: View = .init(frame: contentRect)
      window.contentView = view
      view.layer?.backgroundColor = NSColor.white.cgColor
      return view
   }
}
