# FinanceFlow 💳

Personal finance and subscription manager with on-device machine learning.

Built with SwiftUI, Firebase, and CoreML — trained in Python with scikit-learn.

---

## Features

- Subscription tracking with automatic category detection
- CoreML burn rate model predicts end-of-month balance
- Financial health score and bankruptcy risk analysis
- 6-month spending forecast with native Charts
- Payment day notifications
- Real-time sync with Firebase Firestore

## Machine Learning

The prediction model was trained using Linear Regression in Python, converted to `.mlmodel` with coremltools, and runs fully on-device. Takes monthly income, subscription costs, and previous spending as input.

## Tech Stack

SwiftUI · Firebase Auth · Firestore · CoreML · scikit-learn · Apple Charts

## Screenshots

<!-- add screenshots here -->
![Ana Ekran](screenshots/home.png)
![Analiz](screenshots/analysis.png)

## Getting Started

Clone the repo, add your `GoogleService-Info.plist`, and run in Xcode.


