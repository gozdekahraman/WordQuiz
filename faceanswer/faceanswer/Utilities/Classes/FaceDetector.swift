//
//  FaceDetector.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import Foundation
import Vision

protocol FaceDetectorDelegate: AnyObject {
    func didTiltFaceLeft()
    func didLookStraight()
    func didTiltFaceRight()
}

final class FaceDetector {
    weak var delegate: FaceDetectorDelegate?

    func detectFace(in image: CVPixelBuffer) {
        let faceDetectionRequest = VNDetectFaceLandmarksRequest(completionHandler: { (request: VNRequest, error: Error?) in
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation], results.count > 0 {
                    let result = results[0]
                    let yawAngle = result.yaw?.doubleValue ?? 0
                    let rollAngle = result.roll?.doubleValue ?? 1.5
                    if yawAngle < 0 || rollAngle > 1.8 {
                        self.delegate?.didTiltFaceLeft()
                    } else if yawAngle > 0 || rollAngle < 1.2 {
                        self.delegate?.didTiltFaceRight()
                    } else {
                        self.delegate?.didLookStraight()
                    }
                } else {
                    print("did not detect any face")
                }
            }
        })
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .leftMirrored, options: [:])
        try? imageRequestHandler.perform([faceDetectionRequest])
    }
}
