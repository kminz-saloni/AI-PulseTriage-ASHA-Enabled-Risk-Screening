Project Synopsis
Title  -    AI PulseTriage: ASHA-Enabled Risk Screening

Theme : Healthcare

Problem Statement

65% of India’s population—around 850 million people—lives in rural areas, where 1 million ASHA workers are the backbone of primary healthcare. These workers each manage 1000+ people using memory and paper registers, with no reliable way to track blood pressure, diabetes risk, or TB treatment over time. As a result, hypertension and diabetes are often diagnosed only at the stage of stroke or organ failure, and TB relapse risk is missed because adherence and post-treatment monitoring are not systematically tracked. Connectivity gaps and fragmented data mean that PHC doctors cannot see structured, longitudinal patient information, leading to avoidable hospitalizations, higher mortality, and overloaded district hospitals.

Proposed Solution

 The project proposes an offline-first Android app for ASHA workers, connected to a Google Cloud–based rural health intelligence layer. The app allows voice- and checklist-based data capture in Hindi/local languages, works fully offline in low-network villages, and syncs securely to the cloud whenever connectivity is available. A lightweight on-device risk engine classifies patients into Red / Yellow / Green risk categories for chronic conditions (hypertension, diabetes, TB relapse risk) and suggests referral urgency.
On the cloud side, patient records from multiple ASHAs and PHCs are unified into a longitudinal “micro–health record” for each rural resident. Google Cloud services are used to:
consolidate and normalize ASHA-collected data,run AI/ML models that detect high-risk patterns and missed follow‑ups, and provide PHC and block-level dashboards that highlight the most vulnerable patients and villages.

The platform is designed to integrate gradually with government health systems (ABHA/NDHM) and NTEP/NCD programmes, while strictly keeping within decision-support boundaries (no automated diagnosis).





