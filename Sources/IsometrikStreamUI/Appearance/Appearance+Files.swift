
import Foundation

public struct ISM_Sound {
    
    private static func loadSoundFileSafely(with soundName: String) -> String {
    
        if let path = Bundle.isometrikStreamUIBundle.path(forResource: soundName, ofType: "mp3") {
            return path
        } else {
            print(
                """
                \(soundName) path has failed to load from the bundle please make sure it's included in your resources folder.
                """
            )
            return ""
        }
    }
        
    public var coinDrop : String = loadSoundFileSafely(with: "coin-drop")
    public var successChime : String = loadSoundFileSafely(with: "success-chime")
    
}

public struct ISM_JSON {
    
    private static func loadJSONFileSafely(with fileName: String) -> String {
    
        if let path = Bundle.isometrikStreamUIBundle.path(forResource: fileName, ofType: "json") {
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
        
    public var addAnimation : String = loadJSONFileSafely(with: "add-animation")
    public var emptyBoxAnimation : String = loadJSONFileSafely(with: "Box-animation")
    public var confettiAnimation : String = loadJSONFileSafely(with: "confetti-animation")
    public var successAnimation : String = loadJSONFileSafely(with: "success-animation")
    public var loaderAnimation : String = loadJSONFileSafely(with: "dot-loader")
    
}
