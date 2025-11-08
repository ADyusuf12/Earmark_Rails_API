# 🏠 Earmark API

A Ruby on Rails API‑only application for real estate listings with **JWT authentication**, **role‑based profiles**, and **listing management**. Built with Devise + JWT, Pundit for authorization, and RSpec for testing.

---

## 🚀 Features
- User registration and login with JWT authentication  
- Stateless sessions using devise‑jwt  
- Automatic creation of a UserProfile for each user  
- Supported account types: customer (default), agent, developer, owner  
- Role‑based access control with Pundit policies  
- Listings CRUD with Active Storage for image uploads  
- Saved listings feature for bookmarking properties  
- Dashboards for managing user listings and overview stats  
- Search, sort, and pagination for listings  
- Comprehensive test suite with RSpec, FactoryBot, and Shoulda‑Matchers  

---

## 📂 Project Structure
- `app/models/user.rb` – Devise user model with JWT and profile callback  
- `app/models/user_profile.rb` – Profile model with account type validation  
- `app/controllers/api/v1/registrations_controller.rb` – Custom registration with profile handling  
- `app/controllers/api/v1/listings_controller.rb` – Listings CRUD with JWT + Pundit authorization  
- `app/controllers/api/v1/dashboard/` – Dashboard controllers for overview and listings  
- `spec/requests/` – Request specs for authentication, profiles, listings, and dashboards  
- `spec/policies/` – Policy specs for role‑based access control  
- `spec/factories/` – Factories for users, profiles, and listings  

---

## 🔑 Authentication Endpoints
**Register:** `POST /api/v1/register`  
Creates a new user and profile (defaults to customer if no account_type provided).  

**Login:** `POST /api/v1/login`  
Returns a JWT access token and user data.  

**Logout:** `DELETE /api/v1/logout`  
Revokes the JWT token.  

Responses include a JWT access token and user/profile data.

---

## 🏡 Listings Endpoints
**Create Listing:** `POST /api/v1/listings`  
Requires JWT authentication. Supports image uploads via Active Storage.  

**View Listings:** `GET /api/v1/listings`  
Supports filters (location, price range), keyword search, and sorting (price ascending/descending, newest first).  

**Update/Delete Listing:** `PATCH/DELETE /api/v1/listings/:id`  
Restricted to listing owners via Pundit policies.  

---

## 📊 Dashboard Endpoints
**Overview:** `GET /api/v1/dashboard/overview`  
Returns stats and recent listings for the authenticated user.  

**User Listings:** `GET /api/v1/dashboard/listings`  
CRUD endpoints scoped to the current user’s listings.  

---

## 🧪 Testing
Run the test suite with:  
```bash
bundle exec rspec

Includes:

Request specs for authentication, profiles, listings, and dashboards

Model specs for associations, validations, and callbacks

Policy specs for role‑based access control

🛠️ Setup
Clone the repo:

bash
git clone <repo-url>
cd earmark
Install dependencies:

bash
bundle install
yarn install
Set up the database:

bash
rails db:create db:migrate
Run the server:

bash
rails s

📌 Roadmap
Profile enrichment (bio, contact info, profile picture)

Notifications and messaging between users

Payments and subscriptions for premium listings

Analytics for listing views and conversions

Mobile app integration (React Native or Flutter)

🤝 Contributing
Fork the repository

Create a new branch: git checkout -b feature/your-feature

Commit your changes: git commit -m "Add some feature"

Push to the branch: git push origin feature/your-feature

Open a Pull Request
