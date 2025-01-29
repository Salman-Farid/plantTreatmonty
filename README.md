Here’s the updated README file with the necessary details about the quantized PyTorch model (EfficientNet-B0), class labels, and API deployment. I’ve also included the links to the FastAPI server and GitHub repositories.

---

# 🌱 PlantTreatmonty: Plant Disease Detection App

PlantTreatmonty is a Flutter-based mobile application designed to help users identify plant diseases, gain plant care insights, and access a library of common plant diseases. Powered by a **quantized PyTorch model (EfficientNet-B0)**, this app provides fast and accurate plant disease detection without relying on server-based predictions. Additional features include user authentication via Firebase, a plant care tips section, and an extensive disease library for users to explore.

---

## 📱 Features

- **Plant Disease Detection**: Quickly identify plant diseases by uploading or capturing plant images. The app uses a **quantized EfficientNet-B0 model** optimized for mobile to provide fast and accurate results.
- **Firebase Authentication**: Secure user login and signup powered by Firebase.
- **Plant Care Tips**: Discover tips for maintaining healthy plants and preventing disease.
- **Disease Library**: Access a comprehensive library of common plant diseases, including images, symptoms, and treatments.
- **Responsive Design**: A user-friendly interface that adapts to various screen sizes for an optimal experience.

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- Firebase project with Authentication enabled.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Salman-Farid/planty.git
   cd planty
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Set up Firebase:

    - Go to the [Firebase Console](https://console.firebase.google.com/), create a new project, and enable Firebase Authentication.
    - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the appropriate directories:
        - `android/app/` for `google-services.json`
        - `ios/Runner/` for `GoogleService-Info.plist`

4. Configure Firebase and ML model assets in `pubspec.yaml`:

   ```yaml
   assets:
     - assets/models/plant_disease_model.pt
   ```

5. Run the app:

   ```bash
   flutter run
   ```

---

## 🌿 Screenshots

<p align="center">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/1.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/2.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/3.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/4.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/5.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/6.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/7.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/8.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/9.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/10.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/12.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/13.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/14.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/15.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/16.png" width="150">
  <img src="https://github.com/Salman-Farid/planty/blob/main/app_screen_shots/17.png" width="150">
</p>



---

## 🔥 Technical Details

- **Flutter Framework**: A cross-platform UI toolkit to build the app for both Android and iOS.
- **Firebase Authentication**: Manages user authentication securely.
- **PyTorch (EfficientNet-B0)**: A quantized deep learning model trained for detecting plant diseases. The model is optimized to perform predictions directly on the device for low latency and offline functionality.
- **Dart**: Main programming language used in Flutter development.

### ML Model Details

- **Model Name**: EfficientNet-B0 (Quantized)
- **Classes**: 66
- **Plants**: 13
- **Class Labels**:
  ```plaintext
  Bitter gourd - Downy Mildew, Bitter gourd - Healthy, Bitter gourd - Jassid, Bitter gourd - Leaf Spot,
  Bitter gourd - Nitrogen Deficiency, Bitter gourd - Nitrogen and Magnesium Deficiency,
  Bitter gourd - Nitrogen and Potassium Deficiency, Bitter gourd - Potassium Deficiency,
  Bitter gourd - Potassium and Magnesium Deficiency, Corn_Blight, Corn_Common_Rust, Corn_Gray_Leaf_Spot,
  Corn_Healthy, Cucumber_Anthracnose, Cucumber_Bacterial Wilt, Cucumber_Downy Mildew, Cucumber_Fresh Leaf,
  Cucumber_Gummy Stem Blight, Eggplant - Epilachna Beetle, Eggplant - Flea Beetle, Eggplant - Healthy,
  Eggplant - Jassid, Eggplant - Mite, Eggplant - Mite and Epilachna Beetle, Eggplant - Nitrogen Deficiency,
  Eggplant - Nitrogen and Potassium Deficiency, Eggplant - Potassium Deficiency, Lentil_Ascochyta blight,
  Lentil_Normal, Lentil_Powdery Mildew, Lentil_Rust, Paddy_bacterial_leaf_blight, Paddy_bacterial_leaf_streak,
  Paddy_bacterial_panicle_blight, Paddy_blast, Paddy_brown_spot, Paddy_dead_heart, Paddy_downy_mildew,
  Paddy_hispa, Paddy_normal, Paddy_tungro, Potato___Early_blight, Potato___Late_blight, Potato___healthy,
  Sugarcane_Healthy, Sugarcane_Mosaic, Sugarcane_RedRot, Sugarcane_Rust, Sugarcane_Yellow,
  Tomato_Bacterial_spot, Tomato_Early_blight, Tomato_Late_blight, Tomato_Leaf_Mold, Tomato_Septoria_leaf_spot,
  Tomato_Spider_mites_Two_spotted_spider_mite, Tomato__Target_Spot, Tomato__Tomato_YellowLeaf__Curl_Virus,
  Tomato__Tomato_mosaic_virus, Tomato_healthy, Wheat_Brown rust, Wheat_Healthy, Wheat_Loose Smut,
  Wheat_Mildew, Wheat_Septoria, Wheat_Stem Rust, Wheat_Yellow rust
  ```

---

## 🌟 Future Improvements

- **Offline Disease Library**: Allow users to access disease information offline.
- **Additional Plant Care Tips**: Expand the database of plant care tips.
- **Community Contributions**: Enable users to submit new diseases and share their experiences.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **PyTorch** for providing tools to deploy efficient machine learning models.
- **Flutter Documentation** for their comprehensive resources.
- **Firebase** for the backend authentication support.
- **FastAPI** for deploying the model API.

---

## 🔗 Links

- **API Server**: [https://plant-disease-detection-2-aa5x.onrender.com/docs#/default/predict_predict__post](https://plant-disease-detection-2-aa5x.onrender.com/docs#/default/predict_predict__post)
- **Model and FastAPI GitHub Repository**: [https://github.com/Salman-Farid/plant_disease_detection.git](https://github.com/Salman-Farid/plant_disease_detection.git)
- **PlantTreatmonty App GitHub Repository**: [https://github.com/Salman-Farid/planty.git](https://github.com/Salman-Farid/planty.git)

---

This updated README includes all the necessary details about the model, class labels, and API deployment. Make sure to replace any placeholders with actual links or paths as needed.
