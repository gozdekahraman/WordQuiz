//
//  QuizViewController.swift
//  faceanswer
//
//  Created by gozde kahraman on 11.07.2022.
//

import UIKit
import SnapKit
import AVFoundation
import Vision

enum QuizState {
    case success
    case fail
    case timeout
}

protocol QuizViewProtocol: LoadingViewProtocol {
    func configureLayout()
    func configure(questionViewWith viewModel: QuestionViewModel?)
    func updateAnswerViews(with selection: QuestionViewModel.ScreenSide?)
    func playSound(for state: QuizState)
    func configure(resultViewWith viewModel: QuestionViewModel, status: QuizState)
    func detectFace(in image: CVPixelBuffer)
}

protocol LoadingViewProtocol: AnyObject {
    func showLoading()
    func dismissLoading()
}

final class QuizViewController: UIViewController {
    // MARK: Subviews
    private lazy var quizView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private lazy var questionView: UIView = {
        let view = UIView()
        view.backgroundColor = FAColor(for: .darkAppColor)
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = FAFont(fontName: .openSansSemiBold, size: 18)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 3
        return label
    }()

    private lazy var leftView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var leftOptionLabel: UILabel = {
        let label = UILabel()
        label.font = FAFont(fontName: .openSansBold, size: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var rightView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10
        return view
    }()

    private lazy var rightOptionLabel: UILabel = {
        let label = UILabel()
        label.font = FAFont(fontName: .openSansBold, size: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var timerView: TimerView = {
        let timerView = TimerView()
        return timerView
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FAFont(fontName: .openSansBold, size: 20)
        button.layer.cornerRadius = 10
        button.setTitle("Next Question", for: .normal)
        button.backgroundColor = FAColor(for: .darkAppColor)
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    private lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.style = .large
        loadingView.color = FAColor(for: .lightAppColor)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()

    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)

    // MARK: Properties
    private let presenter: QuizPresenterProtocol
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let faceDetector = FaceDetector()

    init(presenter: QuizPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        assertionFailure("QuizViewController failed to init. No file")
        return nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    @objc
    private func didTapNextButton() {
        presenter.didTapNext()
    }
}

// MARK: QuizViewProtocol
extension QuizViewController: QuizViewProtocol {
    func configureLayout() {
        view.backgroundColor = .white
        faceDetector.delegate = self
        timerView.delegate = self
        addCameraInput()
        showCameraFeed()
        getCameraFrames()
        captureSession.startRunning()
        configureSubviews()
        configureConstrints()
    }

    func configure(questionViewWith viewModel: QuestionViewModel?) {
        guard let viewModel = viewModel else {
            quizView.isHidden = true
            return
        }
        quizView.isHidden = false
        nextButton.isHidden = true
        timerView.isHidden = false
        timerView.reStartTimer()
        label.text = viewModel.question
        leftOptionLabel.text = viewModel.firstOption
        rightOptionLabel.text = viewModel.secondOption
        updateAnswerViews(with: .middle)
    }

    func updateAnswerViews(with selection: QuestionViewModel.ScreenSide?) {
        leftView.backgroundColor = selection == .left ? FAColor(for: .lightAppColor).withAlphaComponent(0.7) : .clear
        rightView.backgroundColor = selection == .right ? FAColor(for: .lightAppColor).withAlphaComponent(0.7) : .clear
    }

    func configure(resultViewWith viewModel: QuestionViewModel, status: QuizState) {
        switch status {
        case .success:
            leftView.backgroundColor = viewModel.answer == .left ? .green.withAlphaComponent(0.7) : .clear
            rightView.backgroundColor = viewModel.answer == .right ? .green.withAlphaComponent(0.7) : .clear
        case .fail:
            leftView.backgroundColor = viewModel.answer == .left ? .red.withAlphaComponent(0.7) : .clear
            rightView.backgroundColor = viewModel.answer == .right ? .red.withAlphaComponent(0.7) : .clear
        case .timeout:
            leftView.backgroundColor = viewModel.correctAnswer == .left ? .green.withAlphaComponent(0.7) : FAColor(for: .lightTextColor).withAlphaComponent(0.7)
            rightView.backgroundColor = viewModel.correctAnswer == .right ? .green.withAlphaComponent(0.7) : FAColor(for: .lightTextColor).withAlphaComponent(0.7)
        }
        nextButton.isHidden = false
        timerView.isHidden = true
    }

    func detectFace(in image: CVPixelBuffer) {
        faceDetector.detectFace(in: image)
    }

    func playSound(for state: QuizState) {
        switch state {
        case .success:
            SoundPlayer.playSuccessSound()
        case .fail:
            SoundPlayer.playFailSound()
        case .timeout:
            SoundPlayer.playTimeOutSound()
        }
    }

    func showLoading() {
        loadingView.startAnimating()
    }

    func dismissLoading() {
        loadingView.stopAnimating()
    }
}

// MARK: Constraints
private extension QuizViewController {
    func configureSubviews() {
        view.addSubviews(loadingView, quizView)
        quizView.addSubviews(leftView, rightView, questionView, timerView, nextButton)
        leftView.addSubview(leftOptionLabel)
        rightView.addSubview(rightOptionLabel)
        questionView.addSubview(label)

        quizView.isHidden = true
        nextButton.isHidden = true
    }

    func configureConstrints() {
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(80)
        }

        quizView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        leftView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width/2)
        }

        leftOptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        rightView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width/2)
            make.leading.equalTo(leftView.snp.trailing)
        }

        rightOptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        questionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }

        timerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
        }
    }
}

// MARK: FaceDetectorDelegate
extension QuizViewController: FaceDetectorDelegate {
    func didTiltFaceLeft() {
        presenter.didSelectFirstOption()
    }

    func didLookStraight() {
        presenter.didNotAnswer()
    }

    func didTiltFaceRight() {
        presenter.didSelectSecondOption()
    }
}

// MARK: TimerViewDelegate
extension QuizViewController: TimerViewDelegate {
    func timerView(didTimeOut view: TimerView) {
        presenter.didTimeOut()
    }
}

// MARK: Helpers
private extension QuizViewController {
    func addCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera],
            mediaType: .video,
            position: .front).devices.first else {
               fatalError("No back camera device found, please make sure to run SimpleLaneDetection in an iOS device and not a simulator")
        }
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }

    func showCameraFeed() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.frame
    }

    func getCameraFrames() {
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "camera_frame_processing_queue"))
        self.captureSession.addOutput(self.videoDataOutput)
        guard let connection = self.videoDataOutput.connection(with: AVMediaType.video),
            connection.isVideoOrientationSupported else { return }
        connection.videoOrientation = .portrait
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension QuizViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection) {
        guard let frame = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            debugPrint("unable to get image from sample buffer")
            return
        }
        presenter.evaluateCaptureOutput(in: frame)
    }
}
