import pandas as pd
import numpy as np
import re
import nltk
import string
import joblib

# Advanced preprocessing libraries
import demoji
import unidecode
from textblob import TextBlob

# Machine Learning and NLP
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier, VotingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.metrics import (
    classification_report, 
    accuracy_score, 
    precision_score, 
    recall_score, 
    f1_score
)

# Ensure necessary downloads
nltk.download('punkt', quiet=True)
nltk.download('stopwords', quiet=True)

class HateSpeechDetector:
    def __init__(self):
        self.stopwords = set(nltk.corpus.stopwords.words('english'))
        
    def advanced_preprocessing(self, text):
        """
        Comprehensive text preprocessing
        """
        # Handle None or non-string inputs
        if not isinstance(text, str):
            text = str(text)
        
        # Convert to lowercase
        text = text.lower()
        
        # Remove URLs
        text = re.sub(r'http\S+|www\S+|https\S+', '', text, flags=re.MULTILINE)
        
        # Remove emojis
        text = demoji.replace(text, '')
        
        # Normalize unicode characters
        text = unidecode.unidecode(text)
        
        # Remove punctuation
        text = text.translate(str.maketrans('', '', string.punctuation))
        
        # Remove extra whitespaces
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def extract_linguistic_features(self, text):
        """
        Extract advanced linguistic features without spaCy
        """
        # Tokenize the text
        tokens = nltk.word_tokenize(text)
        
        features = {
            'text_length': len(text),
            'word_count': len(tokens),
            'unique_word_ratio': len(set(tokens)) / max(len(tokens), 1),
            'stopword_ratio': len([word for word in tokens if word.lower() in self.stopwords]) / max(len(tokens), 1),
            'sentiment_polarity': TextBlob(text).sentiment.polarity,
            'sentiment_subjectivity': TextBlob(text).sentiment.subjectivity
        }
        
        return features
    
    def train_model(self, dataset_path):
        """
        Train an ensemble hate speech detection model
        """
        # Load dataset
        try:
            df = pd.read_csv(dataset_path)
        except Exception as e:
            print(f"Error loading dataset: {e}")
            return None
        
        # Preprocessing
        df['processed_text'] = df['Content'].apply(self.advanced_preprocessing)
        
        # Prepare data
        X = df['processed_text']
        y = df['Label']
        
        # Vectorization
        vectorizer = TfidfVectorizer(
            max_features=5000, 
            stop_words='english', 
            ngram_range=(1, 2)
        )
        
        # Create models
        models = [
            ('rf', RandomForestClassifier(n_estimators=100, random_state=42)),
            ('lr', LogisticRegression(max_iter=1000)),
            ('svm', SVC(probability=True, kernel='linear'))
        ]
        
        # Voting Classifier
        voting_clf = VotingClassifier(
            estimators=models, 
            voting='soft'
        )
        
        # Split data with stratification
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, 
            test_size=0.2, 
            random_state=42, 
            stratify=y
        )
        
        # Fit the vectorizer
        X_train_vectorized = vectorizer.fit_transform(X_train)
        X_test_vectorized = vectorizer.transform(X_test)
        
        # Train the model
        voting_clf.fit(X_train_vectorized, y_train)
        
        # Predictions
        y_pred = voting_clf.predict(X_test_vectorized)
        
        # Comprehensive Evaluation
        print("Model Performance Metrics:")
        print(classification_report(y_test, y_pred))
        
        # Additional Metrics
        print(f"Accuracy: {accuracy_score(y_test, y_pred)}")
        print(f"Precision: {precision_score(y_test, y_pred, average='weighted')}")
        print(f"Recall: {recall_score(y_test, y_pred, average='weighted')}")
        print(f"F1 Score: {f1_score(y_test, y_pred, average='weighted')}")
        
        # Save model and vectorizer
        joblib.dump(voting_clf, 'hate_speech_detection_model.pkl')
        joblib.dump(vectorizer, 'tfidf_vectorizer.pkl')
        
        return voting_clf
    
    def predict(self, text, model_path='hate_speech_detection_model.pkl', vectorizer_path='tfidf_vectorizer.pkl'):
        """
        Predict hate speech probability
        """
        # Load saved model and vectorizer
        model = joblib.load(model_path)
        vectorizer = joblib.load(vectorizer_path)
        
        # Preprocess text
        processed_text = self.advanced_preprocessing(text)
        
        # Vectorize text
        vectorized_text = vectorizer.transform([processed_text])
        
        # Predict
        prediction = model.predict(vectorized_text)[0]
        probability = model.predict_proba(vectorized_text)[0][1]
        
        return {
            'is_hate_speech': bool(prediction),
            'hate_speech_probability': float(probability)
        }

def main():
    # Initialize detector
    detector = HateSpeechDetector()
    
    # Train model (replace with your dataset path)
    model = detector.train_model(r'C:\Users\ritur\hate_speech_detector\data\HateSpeechDatasetBalanced.csv')
    
    # Example prediction
    if model:
        test_texts = [
            "This is a normal sentence.",
            "Hate speech example with offensive language"
        ]
        
        for text in test_texts:
            result = detector.predict(text)
            print(f"\nText: {text}")
            print(f"Prediction: {result}")

if __name__ == "__main__":
    main()