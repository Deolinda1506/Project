# Third-Party Licenses and Attribution

This project uses the following open-source software and datasets. We are grateful to the developers and researchers who made these tools available.

---

## Backend Dependencies

### PyTorch
- **License**: BSD-3-Clause
- **Copyright**: Copyright (c) 2016-2024 Facebook, Inc (Meta Platforms)
- **URL**: https://pytorch.org/
- **Use**: Deep learning framework for model training and inference

### MONAI (Medical Open Network for AI)
- **License**: Apache License 2.0
- **Copyright**: Copyright (c) MONAI Consortium
- **URL**: https://monai.io/
- **Use**: Swin-UNETR architecture for medical image segmentation
- **Citation**: 
  ```
  Hatamizadeh, A., Nath, V., Tang, Y., Yang, D., Roth, H. R., & Xu, D. (2022).
  Swin UNETR: Swin Transformers for Semantic Segmentation of Brain Tumors in MRI Images.
  In International MICCAI Brainlesion Workshop (pp. 272-284). Springer.
  ```

### FastAPI
- **License**: MIT License
- **Copyright**: Copyright (c) 2018 Sebastián Ramírez
- **URL**: https://fastapi.tiangolo.com/
- **Use**: REST API framework

### SQLAlchemy
- **License**: MIT License
- **Copyright**: Copyright (c) 2005-2024 SQLAlchemy authors and contributors
- **URL**: https://www.sqlalchemy.org/
- **Use**: Database ORM

### Firebase Admin SDK
- **License**: Apache License 2.0
- **Copyright**: Copyright (c) Google LLC
- **URL**: https://firebase.google.com/
- **Use**: Cloud storage for ultrasound images

### OpenCV (opencv-python-headless)
- **License**: Apache License 2.0
- **Copyright**: Copyright (c) 2000-2024 Intel Corporation, Willow Garage Inc., et al.
- **URL**: https://opencv.org/
- **Use**: Image preprocessing

### PyWavelets
- **License**: MIT License
- **Copyright**: Copyright (c) 2006-2024 PyWavelets Developers
- **URL**: https://pywavelets.readthedocs.io/
- **Use**: DWT (Discrete Wavelet Transform) for denoising

### NumPy
- **License**: BSD-3-Clause
- **Copyright**: Copyright (c) 2005-2024 NumPy Developers
- **URL**: https://numpy.org/
- **Use**: Numerical computations

### scikit-learn
- **License**: BSD-3-Clause
- **Copyright**: Copyright (c) 2007-2024 scikit-learn developers
- **URL**: https://scikit-learn.org/
- **Use**: Machine learning utilities

### Matplotlib
- **License**: PSF-based (Matplotlib License)
- **Copyright**: Copyright (c) 2002-2024 Matplotlib Development Team
- **URL**: https://matplotlib.org/
- **Use**: Visualization during training

### Pydantic
- **License**: MIT License
- **Copyright**: Copyright (c) 2017-2024 Samuel Colvin
- **URL**: https://docs.pydantic.dev/
- **Use**: Data validation

### python-jose
- **License**: MIT License
- **Copyright**: Copyright (c) Michael Davis
- **URL**: https://github.com/mpdavis/python-jose
- **Use**: JWT token handling

### passlib
- **License**: BSD License
- **Copyright**: Copyright (c) 2008-2024 Assurance Technologies LLC
- **URL**: https://passlib.readthedocs.io/
- **Use**: Password hashing

---

## Flutter/Dart Dependencies

### Flutter SDK
- **License**: BSD-3-Clause
- **Copyright**: Copyright 2014 The Flutter Authors
- **URL**: https://flutter.dev/
- **Use**: Mobile app framework

### http (Dart package)
- **License**: BSD-3-Clause
- **Copyright**: Copyright (c) 2012, the Dart project authors
- **URL**: https://pub.dev/packages/http
- **Use**: HTTP client for API calls

### shared_preferences
- **License**: BSD-3-Clause
- **Copyright**: Copyright 2013 The Flutter Authors
- **URL**: https://pub.dev/packages/shared_preferences
- **Use**: Local storage for consent and settings

### provider
- **License**: MIT License
- **Copyright**: Copyright (c) 2018 Remi Rousselet
- **URL**: https://pub.dev/packages/provider
- **Use**: State management

### image_picker
- **License**: BSD-3-Clause
- **Copyright**: Copyright 2013 The Flutter Authors
- **URL**: https://pub.dev/packages/image_picker
- **Use**: Camera/gallery access for ultrasound images

### firebase_core / firebase_storage
- **License**: BSD-3-Clause
- **Copyright**: Copyright 2020 The Chromium Authors
- **URL**: https://firebase.flutter.dev/
- **Use**: Firebase integration

---

## Datasets

### Carotid Artery Ultrasound Dataset
- **Source**: [If using public dataset, cite here]
- **License**: [Dataset license]
- **Use**: Training and validation of Swin-UNETR segmentation model
- **Note**: If using proprietary/collected data, specify ethics approval and data collection protocol

---

## Code Reuse

### IMT Calculation Algorithm
- **Source**: Adapted from medical imaging literature
- **Reference**: Clinical guidelines for carotid IMT measurement
- **Modifications**: Custom implementation for 2D ultrasound segmentation masks

---

## Model Weights

### Pretrained Swin-UNETR (if applicable)
- **Source**: MONAI Model Zoo
- **License**: Apache License 2.0
- **URL**: https://github.com/Project-MONAI/MONAI
- **Use**: Transfer learning for medical image segmentation

---

## Compliance

This project complies with:
- **Rwanda Data Protection and Privacy Law (Law N°058/2021)**
- **University of Strathclyde Research Ethics Guidelines**
- **Open Source License Requirements**

All dependencies are used in accordance with their respective licenses.

---

## Full License Texts

Full license texts for all dependencies can be found in their respective repositories or package documentation.

---

**Last Updated**: February 26, 2026
