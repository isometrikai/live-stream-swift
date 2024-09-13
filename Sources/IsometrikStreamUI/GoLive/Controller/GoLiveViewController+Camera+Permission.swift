
import UIKit
import AVFoundation

extension GoLiveViewController {
    
    func requestCameraPermission(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        completion(true)
                    } else {
                        self.showPermissionDeniedAlert(on: viewController)
                        completion(false)
                    }
                }
            }
        case .denied, .restricted:
            self.showPermissionDeniedAlert(on: viewController)
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    func showPermissionDeniedAlert(on viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "You have denied camera access. Please go to Settings to enable it.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        })
        
        viewController.present(alert, animated: true, completion: nil)
    }

    
    func createSession(){
        
        requestCameraPermission(from: self) { [weak self] granted in
            
            guard granted else {
                self?.view.showToast(message: "Camera permission not granted")
                return
            }
            
            self?.viewModel.captureSession = AVCaptureSession()
            self?.viewModel.captureSession?.automaticallyConfiguresCaptureDeviceForWideColor = false
            self?.viewModel.captureSession?.sessionPreset = .medium
            
            guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                self?.view.showToast(message: "No front camera.")
                return
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: frontCamera)
                
                let stillImageOutput = AVCapturePhotoOutput()
                
                let canAddInput = self?.viewModel.captureSession?.canAddInput(input) ?? false
                let canAddOutput = self?.viewModel.captureSession?.canAddOutput(stillImageOutput) ?? false
                
                if canAddInput && canAddOutput {
                    self?.viewModel.captureSession?.addInput(input)
                    self?.viewModel.captureSession?.addOutput(stillImageOutput)
                    self?.viewModel.stillImageOutput = stillImageOutput
                }
            }
            catch let error  {
                print("Error Unable to initialize back camera:  \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func setupLivePreview() {
        
        guard let captureSession = viewModel.captureSession
        else { return }
        
        viewModel.videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        viewModel.videoPreviewLayer.videoGravity = .resizeAspectFill
        viewModel.videoPreviewLayer.connection?.videoOrientation = .portrait
        cameraView.layer.addSublayer(viewModel.videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
        
        viewModel.videoPreviewLayer.frame = self.cameraView.bounds
        
    }
    
    func updateCameraStatus(forStreamType: GoLiveStreamType) {
        
        switch forStreamType {
        case .guestLive:
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                // start capture session
                self.viewModel.captureSession?.startRunning()

                DispatchQueue.main.async {
                    self.cameraView.isHidden = false
                }
                
            }
            
        case .fromDevice:
            
            DispatchQueue.global(qos: .userInitiated).async {
                // stop capture session
                self.viewModel.captureSession?.stopRunning()
                DispatchQueue.main.async {
                    self.cameraView.isHidden = true
                }
            }
            
        }
    }
    
}
