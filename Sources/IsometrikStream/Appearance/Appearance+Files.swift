
import UIKit

public struct ISM_JSON {
    
    private static func loadJSONFileSafely(with fileName: String) -> String {
    
        if let path = Bundle.isometrikStreamBundle.path(forResource: fileName, ofType: "json") {
            return path
        } else {
            print(
                """
                \(fileName) path has failed to load from the bundle please make sure it's included in your resources folder.
                """
            )
            return ""
        }
    }
    
    public var loaderAnimation : String = loadJSONFileSafely(with: "dot-loader")
}
