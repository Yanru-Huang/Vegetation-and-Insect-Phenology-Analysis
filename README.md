# Climate change has desynchronised insect and vegetation phenologies across Europe

## Project Overview

This project investigates the impact of climate change on the synchrony of plant and insect phenologies across Europe. Employing a blend of remote sensing and citizen science data spanning 34 years, we analysed the trends in the occurrence dates of 1,584 herbivorous insects across four orders, alongside the corresponding dates of leaf unfolding. Our analysis focuses on assessing their changing relationship and the environmental drivers behind this mismatch phenomenon.

## Files Description

### 01 - Insect multi-phenology patterns classification

The code is written to categorise insect occurrence records based on their degree of voltinism. Insects with varying voltinism exhibit different phenological patterns - either unimodal (single peak of activity) or multimodal (multiple peaks). These patterns are critical for understanding insect population dynamics and community interactions.
- Create the probability density curve for each species occurrence record.
- Smooth the probability density curve using Gaussian and S-G filters.
- Determine whether the phenology is characterised by multiple peaks (using the find_peaks() function from scipy package).
- If it has the multi-peak phenology, K-means clustering is performed. The Silhouette Scores is used to find the optimal cluster number.

### 02 - Vegetation and insect phenology analysis
The primary objective of this R script is to investigate the effects of year, latitude, and longitude on vegetation phenology (LUD), insect phenology (IOD), and their difference (VID) using a quantile regression model. It aims to calculate the trends of these changes over time.
- Use the quantile regression model to analyse the trends in vegetation and insect phenology.
- Record the coefficients and significance of the quantile regression model results.

### 03 - Environmental factors impact analysis
This code is designed to analyse the sensitivity and contribution of environmental factors to vegetation phenology (IOD) and insect phenology (LUD) using partial correlation, ridge regression, and random forest methods. Environmental factors include: total_evaporation_sum(evapotranspiration), hu(average relative humidity), rr(precipitation), qq(radiation), tg(average temperature), fg(average wind speed), volumetric_soil_water_layer_(soil moisture), soil_temperature_level_1(soil temperature).
- Data Matching: Obtain environmental factors for the 0 to 6 months preceding the IOD and LUD records, and calculate the mean values of these environmental factors for the periods 0 to 1, ..., 6 months.
- Geographic Zoning: Considering the geographical variations in environmental factors' impacts, we categorise records into 5°x5° zones, moving 1° each time in latitude and longitude, to perform statistical analyses (only retaining results where a single grid contains data for more than 10 species with over 200 records).
- Optimal Pre-Season Selection: For each phenological pattern, after removing inter-annual trends using linear regression, we conduct correlation analyses between LUD/IOD and environmental factors to identify the period with the highest absolute correlation as the optimal pre-season.
- Partial Correlation/Ridge Regression/Random Forest Analysis: Using the optimal pre-season values of environmental variables, after removing yearly trends and standardising, we execute the respective analyses.

## References

https://doi.org/10.1101/2023.12.11.571152
