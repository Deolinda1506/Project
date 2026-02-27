# ML Model Bias and Fairness Analysis

**Project**: StrokeLink - AI-Assisted Carotid IMT Analysis  
**Model**: Swin-UNETR for Ultrasound Segmentation  
**Date**: February 2026  
**Ethics Requirement**: Part D, Question 19

---

## 1. Model Overview

**Architecture**: Swin-UNETR (Swin Transformer + U-Net)  
**Task**: Semantic segmentation of carotid artery from 2D ultrasound images  
**Output**: IMT (Intima-Media Thickness) measurement in millimeters  
**Clinical Use**: Stroke risk assessment (IMT ≥ 0.9 mm = High Risk)

---

## 2. Training Data Characteristics

### Dataset Composition
- **Source**: [Specify: public dataset, hospital partnership, or collected data]
- **Sample Size**: [Number of images/patients]
- **Geographic Origin**: [Specify countries/regions]
- **Demographics**:
  - Age range: [Specify]
  - Gender distribution: [Specify]
  - Ethnicity: [Specify if available]
  - Clinical conditions: [Specify inclusion/exclusion criteria]

### Potential Biases in Training Data

1. **Geographic Bias**
   - **Risk**: If training data is primarily from [specific region], model may perform poorly on Rwandan population
   - **Impact**: Reduced accuracy for target user base
   - **Mitigation**: [Planned data collection from Rwanda / Fine-tuning on local data]

2. **Equipment Bias**
   - **Risk**: Training data from high-end ultrasound machines may not generalize to low-resource settings
   - **Impact**: Poor performance on images from older/cheaper equipment
   - **Mitigation**: Test on multiple ultrasound machine types

3. **Age Bias**
   - **Risk**: Training data may over-represent certain age groups
   - **Impact**: IMT estimation errors for under-represented ages
   - **Mitigation**: Document age distribution and model limitations

4. **Gender Bias**
   - **Risk**: Unbalanced gender representation in training data
   - **Impact**: Different error rates for male vs. female patients
   - **Mitigation**: Report gender-specific performance metrics

---

## 3. Known Model Limitations

### Technical Limitations

1. **Image Quality Dependency**
   - Model requires reasonably clear ultrasound images
   - **Poor performance** on: severely noisy, motion-blurred, or low-contrast images
   - **Recommendation**: Re-scan if image quality is insufficient

2. **Anatomical Variations**
   - May struggle with: calcifications, plaques, or atypical vessel anatomy
   - **Recommendation**: Flag unusual cases for manual review

3. **Resolution Constraints**
   - Trained on 224×224 pixel images
   - **Poor performance** on very low-resolution inputs (<100×100)

### Clinical Limitations

1. **Not a Diagnostic Device**
   - This is a **research tool**, not FDA/CE/regulatory approved
   - **Must be verified** by qualified medical professionals
   - **Not a substitute** for clinical judgment

2. **Threshold Sensitivity**
   - 0.9 mm threshold for "High Risk" is population-dependent
   - May need adjustment for Rwandan population norms

3. **Single Measurement Limitation**
   - Clinical practice uses multiple measurements
   - Model provides single-frame analysis

---

## 4. Fairness Considerations

### Subgroup Performance Analysis

| Subgroup | Expected Performance | Mitigation |
|---|---|---|
| **Age < 30** | Potentially lower (if under-represented) | Document limitations |
| **Age > 70** | Potentially lower (if under-represented) | Document limitations |
| **Female** | Monitor for bias vs. male | Report gender-specific metrics |
| **Rwandan population** | Unknown if trained on other regions | Local validation study |
| **Low-resource equipment** | Potentially lower | Test on target devices |

### Bias Metrics to Monitor

1. **Demographic Parity**: Equal prediction rates across groups
2. **Equalized Odds**: Equal true positive/false positive rates
3. **Calibration**: Predictions equally reliable across groups

**Status**: [Pending validation data collection from target population]

---

## 5. Ethical Safeguards

### Implemented

1. ✅ **Informed Consent**: Users must consent before data collection
2. ✅ **Data Privacy**: Complies with Rwanda DPA Law N°058/2021
3. ✅ **Transparency**: Model limitations disclosed in app
4. ✅ **Human Oversight**: Results require clinician verification
5. ✅ **Right to Withdraw**: Users can delete data within 30 days

### Recommended Practices

1. **Clinical Validation**: Conduct validation study on Rwandan population
2. **Continuous Monitoring**: Track prediction accuracy by demographic subgroups
3. **Feedback Loop**: Allow clinicians to flag incorrect predictions
4. **Model Versioning**: Document model version with each prediction
5. **Uncertainty Quantification**: Flag low-confidence predictions

---

## 6. Risk Assessment

### High Risk Scenarios

1. **False Negative (High Risk → Predicted Low Risk)**
   - **Impact**: Patient not referred for treatment
   - **Severity**: **Critical**
   - **Mitigation**: Conservative threshold, manual verification

2. **False Positive (Low Risk → Predicted High Risk)**
   - **Impact**: Unnecessary anxiety, additional testing
   - **Severity**: Moderate
   - **Mitigation**: Clear communication of uncertainty

### Medium Risk Scenarios

1. **Equipment Incompatibility**
   - **Impact**: Poor performance on specific ultrasound machines
   - **Mitigation**: Device compatibility testing

2. **User Error**
   - **Impact**: Incorrect image acquisition → poor predictions
   - **Mitigation**: Training materials for healthcare workers

---

## 7. Bias Mitigation Strategies

### Pre-Deployment

1. **Collect local validation data** from Rwandan healthcare facilities
2. **Fine-tune model** on Rwandan population (if performance gaps detected)
3. **Establish baseline metrics** on diverse test set

### Post-Deployment

1. **Monitor prediction distributions** by facility, operator, patient demographics
2. **Collect feedback** from clinicians on prediction quality
3. **Regular audits** (quarterly) of model performance
4. **Retrain model** if significant bias detected

---

## 8. Transparency & Disclosure

### User-Facing Information

**In-App Disclosure**:
> "This AI model is a research tool and may have reduced accuracy for certain populations or equipment types. Always verify results with a qualified healthcare professional."

**Consent Form Section**:
> "The AI model may have limitations when used on populations not well-represented in the training data. Results should be interpreted by trained medical staff."

### Clinician-Facing Information

- Model training data source and demographics
- Known failure modes (e.g., calcified plaques)
- Recommended use cases and contraindications
- Version number and last update date

---

## 9. Future Work

1. **Prospective Clinical Trial**: Compare model predictions to expert measurements
2. **Subgroup Analysis**: Measure performance across age, gender, ethnicity
3. **Explainability**: Implement GradCAM or similar to visualize model attention
4. **Uncertainty Estimation**: Add confidence scores to predictions
5. **Fairness Metrics**: Compute demographic parity, equalized odds on validation set

---

## 10. References

- Hatamizadeh, A., et al. (2022). Swin UNETR: Swin Transformers for Semantic Segmentation. MICCAI.
- Rwanda DPA Law N°058/2021 of 13/10/2021
- University of Strathclyde Research Ethics Guidelines
- WHO Guidelines on Ethical Issues in Medical AI (2021)

---

## Approval & Accountability

**Prepared By**: [Your Name], Student Researcher  
**Supervised By**: [Supervisor Name], University of Strathclyde  
**Ethics Approval**: [Reference Number if available]  
**Last Updated**: February 26, 2026

---

**Declaration**: This document will be updated as new bias/fairness issues are identified during deployment and validation.
