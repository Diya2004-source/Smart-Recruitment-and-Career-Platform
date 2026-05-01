# Smart Recruitment and Career Platform

A comprehensive, full-stack recruitment ecosystem built to streamline the hiring process for recruiters and provide AI-driven career tools for candidates. This platform features a high-performance **Flutter** frontend integrated with a robust **Django** backend.

##  Key Features

*   **Role-Based Dashboards:** Custom workflows for Candidates, Recruiters, and Admins with secure, automated redirection.
*   **AI-Powered Resume Ecosystem:** Includes an ATS-friendly resume builder and scoring system to help candidates optimize their professional profiles.
*   **Intelligent Interview Practice:** An AI-integrated module that provides mock interviews and real-time evaluation using machine learning logic.
*   **Job Management Suite:** Recruiters can post, manage, and validate job openings with a specialized "Premium" interface.
*   **Employee & Student Management (LMS):** Integrated system for tracking attendance, organizational records, and administrative dashboards.

## Technical Stack

*   **Frontend:** Flutter & Dart (Mobile & Web)
*   **Backend:** Python, Django & Django REST Framework (DRF)
*   **Database:** MySQL & Firebase
*   **UI/UX:** Custom "Premium" theme featuring a consistent orange-and-white visual hierarchy.

##  Development Challenges & Solutions

Building this platform involved overcoming several architecture-level hurdles:

*   **API Design & Integration:** Developed secure, role-based RESTful APIs to handle data flow between multiple user types.
*   **Frontend-Backend Synchronization:** Successfully connected a Flutter mobile/web interface to a Django backend, overcoming initial hurdles in asynchronous data fetching and session persistence.
*   **Complex Data Logic:** Implemented intricate logic for the ATS scanner and AI interview feedback system to ensure accuracy and performance.

##  Project Structure

```text
├── Smart_Recruitment_Flutter/   # Flutter Frontend
│   ├── lib/
│   │   ├── services/           # API and Session handlers
│   │   ├── screens/            # UI Pages (Login, Registration, Dashboards)
│   │   └── widgets/            # Reusable UI components
├── Smart_Recruitment_Backend/   # Django REST Backend
│   ├── api/                    # API Endpoints and logic
│   ├── core/                   # User models and authentication
│   └── resume_ai/              # ML logic for resume/interview modules
```

##  Installation & Setup

### Prerequisites
*   Flutter SDK
*   Python 3.x
*   MySQL

### Backend Setup
1.  Navigate to the backend folder: `cd Smart_Recruitment_Backend`
2.  Install dependencies: `pip install -r requirements.txt`
3.  Configure your database in `settings.py`.
4.  Run migrations: `python manage.py migrate`
5.  Start the server: `python manage.py runserver`

### Frontend Setup
1.  Navigate to the frontend folder: `cd Smart_Recruitment_Flutter`
2.  Install packages: `flutter pub get`
3.  Update the `baseUrl` in your service files to match your local server IP.
4.  Run the app: `flutter run`

---

##  About the Developer

I am a software development student focused on creating high-impact mobile and web applications. This project serves as a capstone of my expertise in the **Flutter + Django** stack.

**I am currently seeking Internship opportunities in Flutter or Django Development.**

*   **GitHub:** [Diya2004-source](https://github.com/Diya2004-source)
*   **Project Link:** [Smart-Recruitment-and-Career-Platform](https://github.com/Diya2004-source/Smart-Recruitment-and-Career-Platform)

---

## License
This project is for portfolio purposes. Please contact the developer for usage rights.
