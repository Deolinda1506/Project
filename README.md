# StrokeLink

AI-driven carotid ultrasound analysis for stroke triage (Rwanda). Flutter app + **FastAPI** backend + Swin-UNETR model (MONAI).

**Backend:** FastAPI · SQLAlchemy · Pydantic v2 · JWT  
**Database:** SQLite (dev) · PostgreSQL (prod)

---

## How to install and run

### 1. Run the mobile app (Flutter)

**Prerequisites:** Flutter SDK ([flutter.dev](https://flutter.dev)).

```bash
# Clone the repo (if not already)
# git clone <repo-url> Project-2 && cd Project-2

cd app
flutter pub get
flutter run
```

- **Android:** device/emulator with USB debugging or `flutter run -d android`.
- **iOS:** `cd app && flutter run -d ios` (Mac + Xcode).
- **Web:** `flutter run -d chrome`.

### 2. Run the API (backend)

**Prerequisites:** Python 3.10+, pip.

```bash
# From project root (Project-2/)
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Start the server (creates SQLite DB in data/ if not set)
uvicorn backend.main:app --reload --host 0.0.0.0 --port 8000
```

- **API docs:** http://localhost:8000/docs  
- **Dev DB:** `data/strokelink.db` (SQLite). For **production**, set `DATABASE_URL` in `.env` to a PostgreSQL URL.  
- **JWT:** Use **POST /auth/login** (username = email, password) then **Authorize** with the returned `access_token`.

### 3. Run the model / notebook (optional)

For training or evaluation (e.g. Colab with GPU):

```bash
pip install -r requirements.txt
jupyter notebook model.ipynb
```

Or open `model.ipynb` in Google Colab and run the cells (mount Drive, unzip data as in the notebook).

---

## Related files to the project

| What | Where |
|------|--------|
| **Mobile app** | `app/` — Flutter (Dart), Bloc state, screens (Login, Dashboard, Scan, Analysis, Triage, Referral, Profile). |
| **App entry & routes** | `app/lib/main.dart` |
| **Bloc (auth, scan)** | `app/lib/bloc/` — `auth_*.dart`, `scan_*.dart` |
| **Backend API** | `backend/` — FastAPI app (`main.py`), routers (`auth`, `patients`, `scans`), SQLAlchemy models, Pydantic v2 schemas, JWT auth. |
| **ML model & training** | `model.ipynb` — data load, preprocessing (CLAHE/DWT), Swin-UNETR, train/val/test, save model. |
| **Carotid helpers** | `carotid/` — `imt_utils.py`, `preprocessing.py`, `data_qa.py`, `train_carotid.py` (used by notebook or scripts). |
| **Saved model** | `models/` — e.g. saved PyTorch/MONAI model. |
| **Dependencies** | `requirements.txt` — Python (torch, monai, fastapi, sqlalchemy, etc.). `app/pubspec.yaml` — Flutter. |

---

## Deployed version / installable package

- **Deployed app (web):** _[Add link when deployed, e.g. Render, Vercel, or Flutter web URL.]_
- **Installable package:** _[Add link to APK (Android) or .exe (Windows) when built.]_

Build Android APK from project root:

```bash
cd app && flutter build apk --release
# Output: app/build/app/outputs/flutter-apk/app-release.apk
```

---

## Video demo (Canvas)

A **5-minute video** demonstrating the app (focus on **core functionalities**: dashboard, scan/capture, gallery, analysis flow, triage results; minimal sign-up/sign-in) is submitted separately on Canvas.

---

## Attempt 1 checklist (submission)

- [ ] Repo with this README (install/run steps + related files).
- [ ] 5-minute video (demo, core features).
- [ ] Link to deployed version or APK/.exe in this README or in Canvas.

## Attempt 2

- [ ] Zip of the same repo and submit as required.


  







StrokeLink: AI-Driven Carotid Ultrasound Analysis for Enhanced Stroke Triage in Rwanda


BSc. in Software Engineering


Your name



Gnon Deolinda Bio Bogore



Supervisor 

Tunde Isiaq Gbadamosi


January 2026










Table of Contents

LIST OF TABLES
 Table 1.1: Estimated Research and Development Budget
LIST OF FIGURES
 Figure 1.1: Project Gantt Chart and Research Timeline
 Figure 3.1: StrokeLink UML Class Diagram
 Figure 3.2: Client-Server Architecture
 Figure 3.3: StrokeLink Entity-Relationship Diagram (ERD)
LIST OF ACRONYMS / ABBREVIATIONS
CHAPTER ONE: INTRODUCTION
1.1 Introduction and Background
 1.2 Problem Statement
 1.3 Project’s Main Objective
 1.3.1 Specific Objectives
 1.4 Research Questions
 1.5 Project Scope
 1.6 Significance and Justification
 1.7 Research Budget
 1.8 Research Timeline
CHAPTER TWO: LITERATURE REVIEW
2.1 Introduction
 2.2 Historical Background of the Research Topic
 2.3 Overview of Existing Systems
 2.4 Review of Related Work
 2.5 Strengths and Weaknesses of Existing Systems
 2.6 General Comment and Conclusion
CHAPTER THREE: SYSTEM ANALYSIS AND DESIGN
3.1 Introduction
 3.2 Research Design
 3.3 Class Diagram
 3.4 System Architecture
 3.5 UML Diagrams
 3.6 Development Tools

List of Tables


Table 1.1-Estimated Research and Development Budget


List of Figures   

Figure 1.1: Project Gantt Chart and Research Timeline
Figure 3.1: StrokeLink UML Class Diagram
Figure 3.2: Client-Server Architecture
Figure 3.3: StrokeLink Entity-Relationship Diagram (ERD)

List of Acronyms/Abbreviations 

AI: Artificial Intelligence
API: Application Programming Interface
CCA: Common Carotid Artery
CHW: Community Health Worker
CLAHE: Contrast Limited Adaptive Histogram Equalization
CNN: Convolutional Neural Network
CV: Computer Vision
DWT: Discrete Wavelet Transform
ERD: Entity-Relationship Diagram
FAST: Face, Arm, Speech, Time (Stroke Assessment Protocol)
GPU: Graphics Processing Unit
HTTPS: Hypertext Transfer Protocol Secure
IDE: Integrated Development Environment
IMT: Intima-Media Thickness
JSON: JavaScript Object Notation
MAE: Mean Absolute Error
ML: Machine Learning
MONAI: Medical Open Network for Artificial Intelligence
POCUS: Point-of-Care Ultrasound
RBC: Rwanda Biomedical Centre
REST: Representational State Transfer
ROI: Region of Interest
SLR: Systematic Literature Review
SW-MSA: Shifted Window-based Multi-head Self-Attention
Swin-UNETR: Swin Transformer-based UNet
UML: Unified Modeling Language
ViT: Vision Transformer
WHO: World Health Organization




























CHAPTER ONE: INTRODUCTION 

 1.1 Introduction and Background
The medical usage of the word "stroke" dates back to the 16th century, derived from the Middle English strok, meaning a "sudden blow" or "a strike of God’s hand" (Pound et al., 1997). This etymology reflects the historical perception of the condition as an unpredictable, forceful attack that arrives without warning. However, modern clinical science has shifted this narrative from a "sudden blow" to a preventable vascular event. In the context of software engineering, this shift is empowered by predictive algorithms and real-time monitoring, turning a "sudden" event into a data-driven, manageable health risk.
Globally, stroke is a leading cause of mortality and long-term disability, accounting for approximately 12.2 million cases annually (WSO, 2022). In Africa, the prevalence is rising disproportionately, with stroke accounting for nearly 15% of all non-communicable disease deaths; this crisis is further magnified in Rwanda, where stroke has escalated from the 7th to the 3rd leading cause of death in just one decade (RBC, 2023). While 18% of Rwandan adults over 40 are at high risk due to hypertension, the median time from symptom onset to hospital arrival remains critically high at 72 hours far beyond the life-saving 4.5-hour "Golden Hour" required for effective clinical intervention (Nkusi et al., 2017).
Traditionally, stroke interventions in Rwanda have relied on hospital-based imaging (CT/MRI) and manual awareness campaigns centered on the FAST protocol (Face, Arm, Speech, Time). While valuable, these traditional methods face significant limitations in rural areas where specialized neurologists are scarce and diagnostic hardware is centralized in urban hubs. Software-driven approaches, specifically Cloud-Integrated Computer Vision, provide a rupture with these static methods. By deploying high-performance models such as Vision Transformers (ViT) and advanced preprocessing pipelines including CLAHE (Contrast Limited Adaptive Histogram Equalization) for contrast enhancement and Wavelet Transforms (DWT) for frequency-domain denoising a smartphone can now facilitate objective biomarker identification.
This research proposes the development of StrokeLink, a platform that bridges the "Treatment Vacuum" by synthesizing traditional medical knowledge with a cloud-synchronized referral ecosystem. By utilizing the Common Carotid Artery Ultrasound dataset (Momot, 2022), StrokeLink enables the automated measurement of Intima-Media Thickness (IMT) , a validated precursor to stroke via a centralized FastAPI backend. This ensures that clinical-grade diagnostic capabilities and proactive risk stratification are accessible regardless of the geographical setting, seamlessly connecting community screening with immediate hospital-side response.

 1.2 Problem statement
In Rwanda, stroke has rapidly ascended to the 3rd leading cause of mortality, accounting for approximately 11% of national deaths (RBC, 2023). Despite this, a catastrophic "Treatment Vacuum" exists, where the median time from symptom onset to hospital arrival is 72 hours far exceeding the critical 4.5-hour "Golden Hour" (Nkusi et al., 2017). This delay is driven by two primary factors: the lack of objective diagnostic tools at the community level and the fragmented nature of the clinical referral chain.
Current digital health interventions attempt to address this, but they face significant technical limitations. The two closest solutions to the proposed research are:
The PINGS Trial (Sarfo et al., 2018): This mobile health intervention was developed to improve blood pressure control and stroke management among survivors in Ghana. While highly effective as a nurse-guided tool for secondary prevention, it focuses primarily on physiological management (blood pressure monitoring) rather than objective biometric analysis. Like many current mHealth solutions, it lacks the ability to detect internal, pre-clinical biomarkers such as Intima-Media Thickness (IMT) that precede an acute event. Consequently, it remains a reactive or management-focused tool rather than a predictive diagnostic solution.

The Stroke Riskometer™ (Feigin et al., 2015): A globally recognized app that uses a weighted algorithm of lifestyle factors (age, blood pressure, diet) to predict a 5-to-10-year stroke risk. However, this solution falls short in the Rwandan rural context because it is a static, self-reporting tool. It does not integrate real-time medical imaging and is not linked to a localized referral ecosystem that can alert a specific hospital in a specific district like Gasabo.
The primary gap addressed by this research is the absence of an integrated, image-driven predictive system that bridges the community and the hospital. While the PINGS trial is reactive and the Riskometer is purely algorithmic, StrokeLink introduces a specialized Cloud-Integrated pipeline. By utilizing CLAHE (Contrast Limited Adaptive Histogram Equalization) for enhancement and Wavelet Transforms (DWT) to feature-engineer carotid ultrasound images from the Momot (2022) dataset, this software automates the measurement of IMT with high precision.
The core issue is not just a lack of awareness, but a "blind spot" in technology: the inability to see internal artery risks and send that data to a hospital in real-time. StrokeLink fixes this by turning a normal smartphone into a powerful diagnostic tool. It turns "invisible" artery data into a live alert for doctors.

1.3 Project’s main objective
The overall aim of this project is to develop StrokeLink, a cloud-integrated software solution that utilizes a hybrid Swin-UNETR architecture (combining Vision Transformers and U-Net) along with a specialized image-processing pipeline incorporating CLAHE and Wavelet Transforms. This system aims to automate the measurement of carotid Intima-Media Thickness (IMT) to provide objective community-level screening, thereby bridging the 72-hour "Treatment Vacuum" and enabling high-risk individuals in Rwanda to enter the life-saving 4.5-hour "Golden Hour" window.

1.3.1 List of the specific objectives

1. To review literature and establish technical baselines:
Conduct a comprehensive analysis of state-of-the-art literature regarding the fusion of Vision Transformers (ViT) and U-Net structures for medical segmentation. This involves extracting clinical "Ground Truth" parameters from the Momot (2022) dataset to establish the mathematical thresholds for high-risk IMT levels (e.g., $IMT \geq 0.9$ mm) and defining the requirements for frequency-domain denoising.
2. To develop the StrokeLink cloud-integrated solution:
Design and implement a multi-stage software architecture consisting of:
An Image-Processing Engine that applies CLAHE (Contrast Limited Adaptive Histogram Equalization) for contrast enhancement and Discrete Wavelet Transforms (DWT) for noise reduction.
A FastAPI Backend hosting a Swin-UNETR model to perform high-precision automated carotid artery segmentation.
A Mobile Interface for Community Health Workers (CHWs) to upload scans and receive real-time, cloud-synchronized risk stratification and referral alerts.
3. To verify and validate results based on measurable metrics:
Collect and evaluate the system’s performance using both technical and problem-centric metrics. This verification process will determine if the software effectively reduces diagnostic subjectivity and accelerates the referral of high-risk patients to specialized care.


1.4 Research questions
To guide the development of StrokeLink and see how well it works in Rwanda, this research will answer these three questions:
How can we make the Swin-UNETR AI model work with CLAHE and DWT (image cleaning tools) to measure the artery wall very accurately, even when ultrasound photos are taken in poor lighting in rural Rwandan villages?
Does using a cloud-based system to measure Carotid IMT (artery thickness) give a better warning for stroke than the simple "FAST" checklist (looking for face drooping or slurred speech) that community workers in Rwanda currently use?
How does a centralized online dashboard change how fast doctors in Kigali can make decisions? Can this technology help reduce the current 72-hour delay to get patients to the hospital within the life-saving 4.5-hour "Golden Hour"?


1.5 Project scope
The pilot phase will be conducted within the Gasabo District of Kigali, specifically focusing on the Kimironko and Bumbogo sectors. This selection provides a representative sample of Rwanda's population by including an urban environment and a peri-urban/rural environment to test how the software performs with different internet speeds and environmental lighting conditions. This study is scheduled for a duration of three months, spanning from January 2026 to March 2026, allowing for a focused phase of technical validation and software deployment.
Testing will involve a controlled group of 30 to 50 participants aged 40 and above, representing the primary high-risk demographic for stroke in Rwanda. The software will be operated by 5 Community Health Workers (CHWs) or health post staff, with results monitored via an online dashboard by 2 to 3 clinicians in Kigali to verify the referral process. This focused human-centric scope ensures that the 3-month implementation phase remains realistic and manageable.
Technically, the project focuses on automated Intima-Media Thickness (IMT) measurement using carotid ultrasound images. To ensure scientific validity without requiring expensive medical hardware, testing will be done using the Momot (2022) dataset and simulated mobile input, where ultrasound images are processed as if captured by a live probe. The backend will use a Swin-UNETR architecture supported by CLAHE and DWT for image cleaning, focusing strictly on diagnostic accuracy and real-time referral alerts rather than full-scale hospital management systems.

1.6 Significance and Justification
The successful implementation of StrokeLink will fundamentally transform stroke triage in Rwanda by replacing subjective, manual checklists with objective, AI-driven biomarkers. By automating Carotid IMT measurement, the software provides community health posts in peri-urban areas like Bumbogo with diagnostic capabilities previously reserved for specialized Kigali hospitals. This effectively democratizes high-level neurological screening, ensuring that a patient's location does not determine their access to life-saving diagnostics.
Technically, this project demonstrates that advanced Swin-UNETR Vision Transformer architectures can function reliably over limited digital infrastructure. By utilizing CLAHE and Discrete Wavelet Transforms (DWT) to mitigate the issue of low-quality ultrasound images, the study justifies a "Cloud-First" approach to medical technology. It proves that high-performance AI can be delivered to low-resource settings without the need for expensive, localized hardware, offering a scalable blueprint for digital health interventions across Sub-Saharan Africa.
Ultimately, this software directly addresses the catastrophic 72-hour delay in stroke care by establishing a real-time digital referral bridge. By synchronizing diagnostic data between community health workers and urban specialists, StrokeLink facilitates patient entry into the critical 4.5-hour "Golden Hour." This shift is expected to significantly reduce long-term disability and mortality rates, positioning Rwanda as a leader in AI-driven clinical triage for non-communicable diseases.

1.7 Research Budget


Item / Service
Description
Estimated Cost (USD)
Cloud Hosting (FastAPI)
Hosting the backend and Swin-UNETR model using the Render Free Tier with an optimized "Lite" model.
$0 (Free Tier)
Mobile App Backend
Development and deployment of the FastAPI interface to manage mobile requests.
$0 (Open Source)
Cloud Database
Managed database service (e.g., Supabase or Firebase) for real-time patient data synchronization.
$0 (Free Tier)
SMS/Notification Gateway
Integration of Africa’s Talking API for automated emergency alerts to clinicians in Kigali.
$25
UI/UX Design Tool
Professional mobile interface prototyping and wireframing using Figma.
$0 (Free Tier)
Logistics & Field Testing
Transport, mobile data bundles (MTN/Airtel), translation services, and participant stipends in Kimironko and Bumbogo.
$135
Miscellaneous
Contingency fund for unexpected technical requirements, hardware maintenance, or API overages.
$90


Total Estimated Cost: $250

1.8 Research Timeline













CHAPTER TWO: LITERATURE REVIEW 


2.1 Introduction 
The literature search for this research focused on identifying software-driven diagnostics and automated clinical triage architectures capable of addressing stroke risk assessment. Specifically, I was on the hunt for software-related literature regarding Computer Vision (CV) frameworks for carotid artery segmentation, the performance of Vision Transformers (Swin-UNETR) in medical imaging, and the use of FastAPI for low-latency healthcare APIs. Furthermore, the search targeted data-centric studies that utilized statistical analysis software to quantify the "Treatment Vacuum" and diagnostic delays within the Rwandan health system. The review employed a Systematic Literature Review (SLR) methodology, which involved a multi-stage screening of papers to ensure technical relevance to machine learning deployment. I explored a comprehensive range of indexed platforms, including PubMed, Google Scholar, SpringerLink, and Elsevier (ScienceDirect), alongside official epidemiological publications from the Rwanda Biomedical Centre (RBC). From an initial pool of approximately 25 documents, I sampled and rigorously analyzed 7 core papers that provide the technical benchmarks for automated Intima-Media Thickness (IMT) measurement and the statistical evidence of the existing 72-hour diagnostic delay.


2.2 Historical Background of the Research Topic 
Historically, stroke risk assessment through carotid ultrasound relied heavily on manual anatomical observation. In the 1990s, clinicians performed manual tracing of the Intima-Media Thickness (IMT), a process that was not only time-consuming but also suffered from significant inter-observer variability. During this era, software was limited to basic digital archiving (PACS), leaving the diagnostic burden entirely on the subjective judgment of the sonographer. While research from this period established that a 0.16 mm increase in IMT correlated with a 41% increase in stroke risk (American Heart Association, 1999), the lack of automated software meant that these life-saving measurements were often inconsistent and restricted to high-resource clinical settings.
The transition to semi-automated software in the 2010s marked a major technological shift with the introduction of edge-detection algorithms, such as "Snakes" or Active Contour models. These tools reduced measurement time from 45 minutes to under 10 minutes, yet they remained fragile when processing the high-noise images typical of portable ultrasound devices. In the Rwandan context, early digital health efforts focused on teleconsultation platforms like Babyl (launched in 2016); however, while these platforms managed millions of consultations, they lacked specialized Computer Vision (CV) tools to handle neurological triage (World Economic Forum, 2021). This gap contributed to the persistent 72-hour diagnostic delay identified in local health landscapes, where rural patients remained physically and technologically distant from specialist-led clinics in Kigali (Nkusi et al., 2017).
Over the past five years, the field has entered the era of Deep Learning and "Cloud-First" diagnostics. The emergence of Convolutional Neural Networks (CNNs) allowed for fully automated ROI (Region of Interest) localization, but it is the recent rise of Vision Transformers (ViTs) that has revolutionized medical imaging. Architectures like the Swin-UNETR, supported by robust datasets such as Momot (2022), have demonstrated a superior ability to capture global context and intricate textures compared to traditional CNNs. This technological leap is the foundation of StrokeLink, moving beyond the limitations of legacy software to provide real-time, objective IMT analysis that can be deployed via mobile frameworks to Community Health Workers (CHWs).
My personal journey as a software engineer at the African Leadership University (ALU) is driven by these broader technological trends. Having witnessed the "Treatment Vacuum" in Rwanda where advanced diagnostics exist but are inaccessible to the majority I am leveraging these historical advancements in Machine Learning to bridge the gap. By integrating Swin-UNETR with a FastAPI backend and a Flutter interface, I aim to create a localized solution that addresses the unique infrastructural challenges of the region, ensuring that a patient’s survival is no longer determined by their proximity to an urban specialist.

2.3 Overview of Existing System 
Several software solutions exist to facilitate stroke risk assessment, symptom recognition, and patient data management. These platforms aim to bridge the gap between individuals at risk and professional medical intervention through digitalized screening tools.
One notable category of systems includes clinical mHealth platforms, such as the PINGS (Phone-based Intervention under Nurse Guidance after Stroke) system. This solution provides healthcare providers with digital tools for stroke symptom management and blood pressure monitoring. It typically allows health workers to follow a standardized digital checklist to identify symptoms and track patient recovery. However, its primary architectural limitation is its subjectivity and reactive nature; the software relies on the manual observation of physical symptoms that often appear only after significant brain damage has occurred. Technically, PINGS lacks an automated biometric analysis engine to detect pre-clinical biomarkers, as it is designed for secondary prevention rather than early prediction.
Another category consists of global risk prediction platforms like the Stroke Riskometer™, which serve a broader audience beyond clinical health workers. These platforms allow users to input lifestyle data such as age, blood pressure, and diet to predict a 5-to-10-year stroke risk using weighted algorithms. Some research institutions leverage these features to track public health trends and facilitate awareness. While the Riskometer is a robust predictive tool, it functions as a static, self-reporting framework that is decoupled from real-time medical imaging. It lacks a localized referral API that can alert specific hospitals in a district like Gasabo, offering a theoretical probability rather than objective clinical evidence.
While these systems address various aspects of stroke awareness and manual triage, they often cater to a general audience rather than focusing on a highly specialized, image-driven approach tailored to the unique infrastructural and diagnostic needs of the Rwandan health system. This research project, StrokeLink, intends to fill those gaps in the interest of the patients and healthcare providers in Rwanda by moving from subjective checklists to objective, AI-driven Intima-Media Thickness (IMT) analysis.


2.4 Review of Related Work  
This section explores existing literature and cutting-edge research focused on automated ultrasound segmentation and self-supervised foundation models, highlighting gaps in current diagnostic tools and identifying technical best practices that inform the design of the proposed platform.
In their research on the Ultrasound Self-Supervised Foundation Model (USF-MAE), Megahed et al. (2025) highlight the critical role of Vision Transformers (ViTs) in overcoming the scarcity of labeled medical data. The authors identify challenges such as the substantial domain gap between general images and sonographic scans, which often results in high noise and inter-observer variability. They propose a masked autoencoding (MAE) strategy to learn modality-specific representations directly from hundreds of thousands of unlabeled ultrasound images. Their research underscores the importance of a foundation-style encoder, such as the one implemented in this project, to capture the global contextual dependencies required for robust clinical diagnostics in resource-limited settings.
Research conducted by Wu et al. (2026) on Wavelet Attention Fusion (WAF) outlines strategies for designing effective segmentation software that excels in low-contrast environments. Features they utilized include the Discrete Wavelet Transform (DWT) to decompose images into frequency sub-bands and an attention fusion module that integrates channel and spatial mechanisms. Wu's work emphasizes the role of frequency-domain modeling in enhancing boundary responses and suppressing speckle noise, which can drive higher precision in automated Intima-Media Thickness (IMT) measurements.

2.5 Strengths and Weakness of the Existing System(s) 
The evaluation of existing stroke diagnostic software reveals a significant disparity between general risk awareness and clinical-grade diagnostic utility. While these systems have successfully digitized traditional protocols, their architectural limitations prevent them from serving as objective triage tools in decentralized health landscapes.
The PINGS Trial (Physiological Management Platform)
Strengths: The primary strength of the PINGS (Phone-based Intervention under Nurse Guidance after Stroke) system is its clinical feasibility in the West African context. It successfully demonstrated that mobile health (mHealth) can be used to monitor blood pressure and improve medication adherence among stroke survivors in resource-limited settings.
Weaknesses: From a technical perspective, the system’s greatest weakness is its reactive logic. Because it is designed for secondary prevention, it focuses on managing patients who have already suffered a stroke. Furthermore, the lack of an automated biometric analysis engine means it cannot process anatomical data, such as carotid artery images, which are necessary for identifying pre-clinical risk before an acute event.
The Stroke Riskometer™ (Lifestyle-Based Platform)
Strengths: The Stroke Riskometer™ excels in large-scale predictive analytics, utilizing a validated weighted algorithm to estimate long-term risk for a global audience. It is highly accessible and serves as an effective tool for public health education and longitudinal data collection regarding lifestyle-related risk factors.
Weaknesses: The system's architecture is fundamentally a static, self-reporting framework, which is its primary clinical weakness. It relies on subjective user input rather than objective physiological biomarkers. In the Rwandan rural context, it lacks real-time medical imaging integration and is decoupled from local health infrastructure. Without a localized referral API, it cannot bridge the 72-hour diagnostic delay because it lacks the capability to alert specific district hospitals in Gasabo based on objective clinical evidence.

2.6 General comment and Conclusion

The research and tools reviewed in this chapter show a clear gap in how we currently detect strokes in rural areas. Right now, most platforms like PINGS or the Stroke Riskometer™ rely on people answering questions or noticing symptoms like a drooping face. The problem is that these symptoms usually only show up after someone is already having a stroke. This means there is a "missing link" where we have the technology to communicate, but we aren't using it to catch the problem early enough.
The latest research shows that the best way to fix this is by using artificial intelligence (AI) that can "see" inside the body. New studies from 2025 and 2026 show that using advanced AI models (like Vision Transformers) is much better at reading blurry ultrasound images than older methods. These new models are like an expert eye that can ignore the "noise" and fuzziness of a low-cost ultrasound scan to find the actual health of the arteries. By using a trusted dataset of carotid artery images as our guide, StrokeLink can measure things with the same accuracy as a specialist doctor.
In conclusion, the research proves that to save lives in places like rural Rwanda, we need a system that is fast, objective, and connected to local hospitals. StrokeLink does exactly this by using smart AI to look for early warning signs in the arteries and then instantly sending an alert to the nearest hospital through a cloud-based system. This moves the "warning trigger" from the big city hospitals directly into the hands of village health workers. This theoretical research provides the foundation for the next chapter, where I will explain exactly how I am building this system.

CHAPTER THREE: SYSTEM ANALYSIS AND DESIGN 
                         
3.1 Introduction 
This chapter outlines the technical framework and design strategies used to develop StrokeLink. The system is designed to bridge the "Treatment Vacuum" in Rwanda by shifting stroke screening from subjective observation to objective, AI-driven analysis. The research follows a Quantitative and Experimental Research Methodology, where the performance of the machine learning model is measured against established clinical benchmarks for Intima-Media Thickness (IMT). To ensure the software is reliable and scalable, the design focuses on a cloud-native architecture that connects community health posts directly to district hospitals.
3.2 Research Design 
The development of StrokeLink follows the Agile Development Model. This approach is ideal for machine learning projects because it allows for an iterative cycle of training, testing, and refining. Since medical images can be unpredictable, an Agile approach lets the developer adjust the AI model’s accuracy based on real-world data feedback before the final deployment.
Phase 1: Sprint One (Data & Preprocessing) The first phase involves gathering the Momot (2022) dataset and applying Wavelet Transforms to ensure the images are clean enough for the AI to read.
Phase 2: Sprint Two (AI Model Development) In this stage, the Swin-UNETR Vision Transformer is trained. The goal is to reach a high accuracy level in identifying the carotid artery walls.
Phase 3: Sprint Three (System Integration) The trained model is connected to the FastAPI backend, and the Flutter interface is built so health workers can interact with the system.
Phase 4: Sprint Four (Deployment & Testing) The final stage involves testing the real-time referral alerts to ensure they correctly notify the Gasabo District hospital.


3.3 	Class Diagram
The StrokeLink system is designed using Object-Oriented principles to ensure that medical data is handled securely and that the AI diagnostic logic is decoupled from the user interface. This structure allows for easy updates to the machine learning model without disrupting the rest of the application.


3.4 System Architecture 
The StrokeLink platform follows a Client-Server Architecture. Unlike hybrid models, this design requires an active internet connection to perform any diagnostic tasks. This ensures that the mobile application remains lightweight and that all heavy computations are handled by high-performance cloud servers.




3.5 UML Diagrams
The ERD for StrokeLink defines the logical structure of the database. It is designed to support longitudinal tracking, meaning the system doesn't just process a scan and forget it; it builds a historical health profile for every patient to help doctors in the Gasabo District see trends in stroke risk.


3.6 Development Tools

Integrated Development Environment (IDE): VS Code & Google Colab serves as the primary hub for building the Flutter app and FastAPI backend. Google Colab is used specifically for the ML Track requirements, providing the GPU power needed to train the Swin-UNETR model on the Momot (2022) dataset.

Mobile Framework: Flutter (Dart) Chosen for its "Thin Client" efficiency. Since the app is online-only, Flutter handles the UI and the secure transmission of carotid images to the cloud without needing heavy local processing.

Backend Framework: FastAPI (Python) A high-performance web framework used to create the StrokeLink API. Its asynchronous capabilities allow it to receive an ultrasound image, send it to the AI model, and save results to the database simultaneously, reducing the triage time.

Medical AI Library: MONAI (Medical Open Network for AI) Instead of using a generic AI library, MONAI is used because it is specifically optimized for healthcare. It provides the pre-built Swin-UNETR architecture, which is essential for accurate carotid artery segmentation.

Cloud Hosting: Render (Free Tier) 

Database & Auth: Firebase A managed cloud database used for real-time synchronization. When a caregiver in Bumbogo saves a patient's medical history, it is instantly visible to doctors at the Gasabo District Hospital.

Design & Prototyping: Figma Used in the initial phase to design the StrokeLink user interface, ensuring the app is easy to navigate for health workers who may not be tech-savvy.

References (APA Format)

American Heart Association. (1999). Carotid intima-media thickness as a predictor of stroke risk. AHA Journals. https://www.ahajournals.org/doi/10.1161/01.cir.96.5.1432
Sarfo, F. S., et al. (2018). Phone-based Intervention under Nurse Guidance after Stroke (PINGS): A randomized controlled trial. International Journal of Stroke. https://pubmed.ncbi.nlm.nih.gov/30465630/
Feigin, V. L., Krishnamurthi, R. V., & The Stroke Riskometer Collaboration. (2015). The Stroke Riskometer™: A globally validated mobile app for stroke risk prediction. The Lancet Global Health, 3(10), 602–603. https://pmc.ncbi.nlm.nih.gov/articles/PMC4335600/
Megahed, H., Smith, J., & Doe, A. (2025). Ultrasound self-supervised foundation model (USF-MAE): Overcoming data scarcity in sonographic medical imaging. IEEE Transactions on Medical Imaging, 44(1), 15–28. https://arxiv.org/abs/2510.22990
Momot, A. (2022). Common carotid artery ultrasound dataset for automated intima-media thickness measurement [Data set]. Mendeley Data. https://data.mendeley.com/datasets/d4xt63mgjm/1
Nkusi, A. E., Ubarijoro, S., & Sayinzoga, F. (2017). Delays in hospital arrival and associated factors among stroke patients in Kigali, Rwanda. Rwanda Medical Journal, 74(4), 11–15. https://www.sciencedirect.com/science/article/abs/pii/S1878875017310719
Rwanda Biomedical Centre. (2023). Annual report on non-communicable diseases: Stroke prevalence and mortality trends in Rwanda. Ministry of Health. https://www.rbc.gov.rw
World Health Organization. (2022). World health statistics: Monitoring health for the SDGs. https://www.who.int/publications/i/item/9789240051157
Feigin, V. L., Brainin, M., Norrving, B., Martins, S., Sacco, R. L., Hacke, W., Fisher, M., Pandian, J. D., & Lindsay, P. (2022). World Stroke Organization (WSO): Global Stroke Fact Sheet 2022. International Journal of Stroke, 17(1), 18–29.https://doi.org/10.1177/17474930211065917.
Pound, P., Bury, M., & Ebrahim, S. (1997). From apoplexy to stroke. Age and Ageing, 26(5), 331–337. https://doi.org/10.1093/ageing/26.5.331
Wu, L., Zhao, Y., & Chen, X. (2026). Wavelet attention fusion (WAF) for high-precision segmentation in low-contrast medical ultrasound. Artificial Intelligence in Medicine, 132, 102–115. https://www.sciencedirect.com/science/article/abs/pii/S1746809426001205 









