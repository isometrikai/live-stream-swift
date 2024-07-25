
import UIKit

public enum UploadStatus {
    case progress(Double)
    case success
    case failure(Error?)
}

public class UploadingManager {
    
    public func uploadImageToS3(presignedURL: URL, image: UIImage, completion: @escaping (UploadStatus) -> Void) {
        
        var request = URLRequest(url: presignedURL)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        // Convert UIImage to Data (JPEG format with quality 0.8)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(nil))
            return
        }
        
        let session = URLSession(configuration: .default, delegate: ProgressDelegate(completion: completion), delegateQueue: nil)
        
        // Create a URLSession upload task
        let task = session.uploadTask(with: request, from: imageData) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(nil))
                return
            }
            
            if httpResponse.statusCode == 200 {
                completion(.success)
            } else {
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Upload failed with status code: \(httpResponse.statusCode)"])
                completion(.failure(error))
            }
        }
        
        // Start the upload task
        task.resume()
    }
    
    public init() {}
    
}

class ProgressDelegate: NSObject, URLSessionTaskDelegate {
    let completion: (UploadStatus) -> Void
    
    init(completion: @escaping (UploadStatus) -> Void) {
        self.completion = completion
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        completion(.progress(progress))
    }
}
