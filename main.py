"""
main.py - FastAPI inference service for RISERURAL CONNECT Crop Production Prediction
"""

import os
import joblib
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, validator
from typing import Optional
from fastapi.middleware.cors import CORSMiddleware

# Model Path
MODEL_PATH = os.getenv("AGRO_MODEL_PATH", "random_forest.joblib")

# Load Model
try:
    model = joblib.load(MODEL_PATH)
except Exception as e:
    raise RuntimeError(f"Failed to load model at {MODEL_PATH}: {e}")

# Identify expected features
try:
    EXPECTED_FEATURES = list(model.named_steps["pre"].feature_names_in_)
except Exception:
    EXPECTED_FEATURES = ["Crop", "State", "Season", "Area"]

# Request / Response Schemas
class PredictionRequest(BaseModel):
    Crop: str = Field(..., min_length=1, description="Crop name (e.g., Maize, Rice)")
    State: str = Field(..., min_length=1, description="State/Region name (e.g., Odisha)")
    Season: Optional[str] = Field(None, description="Season (e.g., Kharif, Rabi, Wet)")
    Area: float = Field(..., ge=0, le=10_000_000, description="Cultivated area (hectares)")

    @validator("Area")
    def area_positive(cls, v):
        if v == 0:
            raise ValueError("Area must be > 0.")
        return v


class PredictionResponse(BaseModel):
    crop: str
    state: str
    season: Optional[str]
    area: float
    predicted_production: float


# FastAPI App
app = FastAPI(
    title="RISERURAL CONNECT Production Prediction API",
    description="Predict crop production (tons) given crop, state, season, and area.",
    version="1.0.0",
)

# Enable CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for now
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health Check
@app.get("/")
def read_root():
    return {"status": "ok", "model_path": {"random_forest_model.joblib"}}

# Prediction Endpoint
@app.post("/predict", response_model=PredictionResponse)
def predict(payload: PredictionRequest):
    """
    Accept raw user inputs; pipeline handles encoding internally.
    """
    row_dict = {
        "Crop": payload.Crop,
        "State": payload.State,
        "Season": payload.Season,
        "Area": payload.Area,
    }

    # Ensure DataFrame contains expected columns
    row = pd.DataFrame([{k: row_dict.get(k, np.nan) for k in EXPECTED_FEATURES}])

    try:
        pred = model.predict(row)
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Prediction failed: {e}")

    return PredictionResponse(
        crop=payload.Crop,
        state=payload.State,
        season=payload.Season,
        area=payload.Area,
        predicted_production=float(pred[0]),
    )
