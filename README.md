#  Smart Recruitment & Career Platform

A full-stack job portal specifically designed for students, featuring **AI-powered resume matching** and **automated skill extraction**.

## 🛠 Tech Stack
- **Backend:** Django, Django REST Framework (DRF)
- **Database:** PostgreSQL / SQLite
- **Auth:** JWT (SimpleJWT)
- **Frontend:** Flutter (Mobile)
- **AI Engine:** (Mention your AI tool here, e.g., PyPDF2, OpenAI, or Spacy)

## 📡 API Reference
The backend is built with a RESTful architecture. Major endpoints include:

### Authentication
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| POST | `/api/token/` | Obtain Access & Refresh tokens |
| POST | `/api/accounts/users/` | Register as CANDIDATE or RECRUITER |

### Jobs & AI Matching
| Method | Endpoint | Description |
| :--- | :--- | :--- |
| GET | `/api/jobs/listings/` | List all available job posts |
| POST | `/api/jobs/applications/` | Apply for a job and receive AI Match Score |

## Getting Started

### Prerequisites
- Python 3.x
- Flutter SDK

### Backend Setup
1. Clone the repo: `git clone <your-url>`
2. Install requirements: `pip install -r requirements.txt`
3. Run migrations: `python manage.py migrate`
4. Start server: `python manage.py runserver`

### Frontend Setup
1. Navigate to frontend folder.
2. Run `flutter pub get`.
3. Start emulator and run `flutter run`.
