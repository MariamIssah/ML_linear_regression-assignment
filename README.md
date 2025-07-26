# Crop Production Prediction 

## Dataset "Non Africanized data"
Finding reliable agricultural datasets specific to Africa proved challenging. Therefore, I decided to use an agriculture dataset from India, which I obtained from Kaggle. Although the data is not African-based, it still represents real-world agricultural production scenarios, and the patterns and techniques learned can be applied in similar contexts. This dataset allowed me to build and train a machine learning model for predicting crop yield based on crop type, season, area, and location.


### Mission

SmartCrop is an intelligent tool built to help farmers predict crop production before actual cultivation based on key inputs like crop type, season, location, and farm size.
This supports data-driven decisions to improve yield and reduce resource waste.
Buyers can also identify high-production zones to guide sourcing.
The tool promotes smarter, more profitable, and sustainable agriculture.


## Problem Statement

Farmers often invest in farming without reliable insight into expected yields, leading to loss, especially during unfavorable seasons.
This tool predicts potential crop production based on historical data, helping farmers choose optimal conditions (like crop type, season, and state).
It also benefits buyers seeking high-production regions for sourcing produce.


## Public API Endpoint

A publicly accessible API endpoint returns predicted production based on the following inputs:

* `Crop` (e.g., Rice, Maize)
* `State_Name` (e.g., Karnataka)
* `Season` (e.g., Kharif)
* `Area` (in hectares)

> **Note**: The API is hosted at:
> ** [Swagger UI](https://ml-linear-regression-assignment.onrender.com/docs)**

Accessible via Swagger UI for testing.



## Mobile App Instructions
Clone the Repository
Use Git to clone this project to your local machine.

Open in Android Studio
Open the Flutter project in Android Studio (or any preferred Flutter IDE).

Install Dependencies
Run flutter pub get in the terminal to install all necessary packages.

Run the App
Launch the app on an emulator or physical device with flutter run or by clicking Run in Android Studio.

Make a Prediction

Input details like crop name, area (in hectares), season, and state.

Tap the Predict button.

The app will display the predicted crop production using the deployed ML model.


## YouTube Demo

Watch the full demo (under 5 minutes):
[Demo video](https://youtu.be/lD6MOaGLx1k)



##  Use Case

This is not a generic model, it targets farmers and agricultural stakeholders in India.
It provides personalized predictions based on multiple contextual inputs, helping:

* Farmers decide what and when to plant
* Buyers locate regions of high yield


## Dataset Summary

The dataset used is rich in volume and variety, covering:

* Different crops (Rice, Maize, Wheat, etc.)
* Multiple Indian states and districts
* Seasonal variations
* Data from multiple years

**Brief Description**:
This dataset contains historical crop production statistics from Indian states and districts. It includes crop type, area cultivated, season, and actual production.
Data Source: \**[India agricultural databases](https://www.kaggle.com/datasets/abhinand05/crop-production-in-india)**


## Features

* Machine Learning Model (e.g., Random Forest.joblib)
* RESTful API with FastAPI
* Swagger UI for interactive testing
* Mobile App (optional frontend)
* Deployment-ready (e.g., Render)
