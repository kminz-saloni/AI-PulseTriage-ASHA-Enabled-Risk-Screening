from fastapi import FastAPI
from pydantic import BaseModel
import numpy as np
import joblib

# Load trained artifacts
model = joblib.load("health_risk_model.pkl")
scaler = joblib.load("scaler.pkl")
gender_encoder = joblib.load("gender_encoder.pkl")
risk_encoder = joblib.load("risk_encoder.pkl")

app = FastAPI(title="Health Risk Prediction API")


@app.get("/")
def root():
    return {
        "message": "Health Risk Prediction API",
        "status": "running",
        "endpoints": {
            "predict": "/predict-risk (POST)",
            "health": "/health (GET)"
        }
    }


@app.get("/health")
def health_check():
    return {"status": "healthy"}


# Input schema (matches your dataset)
class PatientInput(BaseModel):
    heart_rate: float
    body_temperature: float
    systolic_bp: float
    diastolic_bp: float
    age: int
    gender: str
    weight: float
    height: float


@app.post("/predict-risk")
def predict_risk(data: PatientInput):

    # Encode gender
    gender_encoded = gender_encoder.transform([data.gender])[0]

    # Arrange input in correct order
    input_data = np.array([[  
        data.heart_rate,
        data.body_temperature,
        data.systolic_bp,
        data.diastolic_bp,
        data.age,
        gender_encoded,
        data.weight,
        data.height
    ]])

    # Scale
    input_scaled = scaler.transform(input_data)

    # Predict
    prediction = model.predict(input_scaled)
    risk_label = risk_encoder.inverse_transform(prediction)[0]

    return {
        "risk": risk_label
    }
