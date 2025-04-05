HateAway - Real-Time Hate Speech Detection
HateAway is an AI-powered real-time hate speech detection web application.

Users can paste or type any text (tweets, comments, or messages), and the ML model classifies it as hate speech or not hate—instantly and accurately.

🌐 Live Demo
Coming soon...

🧠 How It Works
Users input text via the Flutter-based web/mobile UI.

Text is sent to the backend Flask server.

The server loads a pre-trained machine learning model (.pkl) built using:

TF-IDF Vectorizer

Logistic Regression and SVM

The model returns the prediction: Hate or Not Hate.

⚙️ Tech Stack
Layer	Technology
Frontend	Flutter
Backend	Flask (Python)
ML Model	Scikit-learn (TF-IDF + LR/SVM)
Hosting	Planned with GCP (Firebase, Vertex AI)
📂 Dataset
This project uses a hate speech dataset (~138MB), which is hosted externally due to GitHub's file size limits.

🔗 Download the dataset from Google Drive

🚀 Getting Started
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/candid02/HateAway.git
cd HateAway
2. Backend Setup (Flask)
bash
Copy
Edit
cd backend
pip install -r requirements.txt
python app.py
The backend server will start on http://127.0.0.1:5000.

Make sure the .pkl model file is present in the correct directory.

3. Frontend Setup (Flutter)
bash
Copy
Edit
cd hateaway
flutter pub get
flutter run
✅ Features
Real-time hate speech detection

Simple and clean UI

Fast and accurate classification

Backend powered by pre-trained ML model

📌 Note
Due to GitHub's 100MB file limit, the dataset is not included in the repo. You can download it using the link above if you wish to retrain the model.

🙌 Acknowledgements
Dataset: Kaggle Hate Speech Dataset

Tools: Flutter, Flask, scikit-learn, GCP


