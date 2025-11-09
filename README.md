# 🛠️ Rails API with JWT Authentication and User Profiles

This project is a **Ruby on Rails API‑only application** that provides user authentication with **Devise + JWT** and supports role‑based profiles through a `UserProfile` model. It also includes **role‑based access control (RBAC)** powered by **Pundit**.

---

## 🚀 Features
- **User registration and login** with JWT authentication
- **Stateless sessions** using devise-jwt
- **Automatic creation of a UserProfile** for each user
- Supported account types: `customer` (default), `agent`, `developer`, `owner`
- **Role‑based access control (RBAC)** with Pundit policies
  - Centralized error handling for unauthorized/unauthenticated requests
  - Policies for Listings, SavedListings, and UserProfiles
  - Admin support via `admin` boolean on `User` model
- **Request specs and model specs** with RSpec, FactoryBot, and Shoulda‑Matchers

---

## 📂 Project Structure
- `app/models/user.rb` – Devise user model with JWT, profile callback, and admin helper
- `app/models/user_profile.rb` – Profile model with account type validation
- `app/controllers/api/v1/registrations_controller.rb` – Custom registration with profile handling
- `app/controllers/listings_controller.rb` – Authorized with Pundit policies
- `app/controllers/saved_listings_controller.rb` – Scoped and authorized for index/create/destroy
- `app/controllers/user_profiles_controller.rb` – Scoped to current_user, authorized for show/update
- `spec/requests/registrations_spec.rb` – Request specs for registration
- `spec/requests/listings_spec.rb` – Request specs for listing access and CRUD
- `spec/requests/saved_listings_spec.rb` – Request specs for saving/unsaving listings
- `spec/requests/user_profiles_spec.rb` – Request specs for profile viewing/updating with RBAC
- `spec/policies/` – Policy specs for Listings, SavedListings, and UserProfiles
- `spec/models/user_spec.rb` – User model specs
- `spec/models/user_profile_spec.rb` – UserProfile model specs
- `spec/factories/` – Factories for users, profiles, and listings

---

## 🔑 Authentication Endpoints
- **Register:** `POST /api/v1/register`
  - Creates a new user and profile (defaults to `customer` if no `account_type` provided).

- **Login:** `POST /api/v1/login`
  - Returns a JWT access token and user data.

- **Logout:** `DELETE /api/v1/logout`
  - Revokes the JWT token.

➡️ Responses include a JWT access token and user/profile data.

---

## ✅ Includes
- Request specs for registration, profile creation, listings, and saved listings
- Policy specs for RBAC rules
- Model specs for associations, validations, and callbacks

---

## 🛠️ Setup
- Clone the repo: `git clone <your-repo-url>`
- Move into the folder: `cd <your-repo-folder>`
- Install dependencies: `bundle install`
- Set up the database: `rails db:create db:migrate`
- Run the server: `rails s`

---

## 🧪 Testing
Run the test suite with: `bundle exec rspec`

This will run:
- Request specs for registration, profile creation, listings, and saved listings
- Policy specs for RBAC rules
- Model specs for associations, validations, and callbacks

---

## 📌 Next Steps
- Expand API endpoints for profile management
- Add role‑specific models (`Agent`, `Developer`, `Owner`) for richer domain logic

---

## 🤝 Contributing
1. Fork the repository
2. Create a new branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add some feature"`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request
