//
//  ScannerView.swift
//  Mo626 Clone
//
//  Created by Wiza Munthali on 07/01/2026.
//

import AVFoundation
import SwiftUI
import Vision

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scanned: String

    let session = AVCaptureSession()

    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIViewController()

        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let videoInput = try? AVCaptureDeviceInput(device: captureDevice),
            session.canAddInput(videoInput)
        else { return controller }

        session.addInput(videoInput)

        let videoOutput = AVCaptureVideoDataOutput()

        if session.canAddOutput(videoOutput) {
            videoOutput
                .setSampleBufferDelegate(
                    context.coordinator,
                    queue: DispatchQueue(label: "videoQueue")
                )
            session.addOutput(videoOutput)
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        //        previewLayer.frame = controller.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.cornerRadius = 12
        controller.view.layer.addSublayer(previewLayer)

        context.coordinator.previewLayer = previewLayer

        session.startRunning()

        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {
        DispatchQueue.main.async {
            context.coordinator.previewLayer?.frame =
                uiViewController.view.bounds
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: ScannerView
        var previewLayer: AVCaptureVideoPreviewLayer?

        init(parent: ScannerView) {
            self.parent = parent
        }

        func captureOutput(
            _ output: AVCaptureOutput,
            didOutput sampleBuffer: CMSampleBuffer,  // Changed from didDrop
            from connection: AVCaptureConnection
        ) {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
            else { return }
            self.detectBarcode(in: pixelBuffer)
        }

        func detectBarcode(in pixelBuffer: CVPixelBuffer) {
            let request = VNDetectBarcodesRequest()
            let handler = VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: .up,
                options: [:]
            )

            do {
                try handler.perform([request])
                if let results = request.results,
                    let payload = results.first?.payloadStringValue
                {
                    DispatchQueue.main.async {
                        AudioServicesPlaySystemSound(
                            SystemSoundID(kSystemSoundID_Vibrate)
                        )

                        self.parent.scanned = payload
                        self.parent.session.stopRunning()
                    }
                }
            } catch {
                print("Barcode detection failed: \(error)")
            }
        }
    }
}
