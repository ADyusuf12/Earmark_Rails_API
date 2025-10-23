# 🏠 Earmark Real Estate API

A **Ruby on Rails API‑only application** for managing real estate listings, users, and profiles.
Features **JWT authentication with Devise**, **role‑based access control with Pundit**, and a growing set of endpoints for listings, saved properties, dashboards, and more.

This project is being developed as a **personal learning project**, following best practices in GitHub workflow, testing, and clean code.

---

## 🚀 Features

- **Authentication & Profiles**
  - **Devise + JWT** for registration and login
  - Stateless sessions with `devise-jwt`
  - Automatic creation of a `UserProfile` for each user
  - Supported account types: `customer` (default), `agent`, `developer`, `owner`
  - Role‑based access control with **Pundit**

- **Listings**
  - Full **CRUD** for property listings
  - **Filtering**, keyword **search**, and **sorting** (price, newest, etc.)
  - **Pagination** with Kaminari
  - **Image uploads** with Active Storage

- **Saved Listings**
  - Save/unsave listings
  - Prevent duplicates with DB uniqueness constraints

- **Dashboards**
  - User dashboards with owned listings and stats
  - Overview endpoints for quick insights

- **Security & Trust**
  - JWT‑protected endpoints
  - Role‑based authorization policies
  - Pre‑commit hooks with RuboCop for linting and format‑on‑save

- **Testing**
  - Request specs for major endpoints
  - Model & policy specs with **RSpec, FactoryBot, Shoulda‑Matchers**
  - Green test suite (local)

---

## 📂 Project Structure

app/models/user.rb                # Devise user with JWT + profile callback
app/models/user_profile.rb        # Profile model with account type validation
app/models/listing.rb             # Listing model with validations and attachments

app/controllers/api/v1/auth/...   # Sessions, Registrations
app/controllers/api/v1/user_profile_controller.rb
app/controllers/api/v1/listings_controller.rb
app/controllers/api/v1/dashboard/overviews_controller.rb
app/controllers/api/v1/dashboard/listings_controller.rb

app/queries/listings_query.rb     # Filtering, sorting, pagination

spec/requests/...                 # Request specs for API endpoints
spec/models/...                   # Model specs (associations, validations)
spec/policies/...                 # Pundit policy specs
spec/factories/...                # FactoryBot factories


---

## 🔑 API Endpoints (Highlights)

- **Auth**
  - `POST /api/v1/register` → Create user + profile
  - `POST /api/v1/login` → Return JWT + user data
  - `DELETE /api/v1/logout` → Revoke JWT

- **Profile**
  - `GET /api/v1/user_profile` → Current user + profile
  - `PATCH /api/v1/user_profile` → Update profile fields (e.g., account_type, first_name, last_name)

- **Listings**
  - `GET /api/v1/listings` → All listings (filters, keyword search `q`, sorting `sort`, pagination `page`/`per_page`)
  - `POST /api/v1/listings` → Create listing (JWT required)
  - `PATCH /api/v1/listings/:id` → Update owned listing
  - `DELETE /api/v1/listings/:id` → Delete owned listing

- **Saved Listings**
  - `GET /api/v1/saved_listings` → Current user’s saved listings
  - `POST /api/v1/saved_listings` → Save by `listing_id`
  - `DELETE /api/v1/saved_listings/:id` → Unsave by `listing_id`

- **Dashboard**
  - `GET /api/v1/dashboard/overview` → Stats + recent listings
  - `GET /api/v1/dashboard/listings` → CRUD scoped to current user’s listings

---

## 🛠️ Setup

```bash
# Clone the repo
git clone https://github.com/ADyusuf12/earmark.git
cd earmark

# Install dependencies
bundle install
yarn install

# Set up database
rails db:create db:migrate

# Run the server
rails s
Visit: http://localhost:3000

---

## 🧪 Testing

```bash
bundle exec rspec
Covers:

- Auth (login, registration, logout)
- Profiles (show/update)
- Listings (CRUD, filters, keyword search, sorting, pagination)
- Saved listings (index/create/destroy)
- Dashboards (overview + scoped listings)
- Policies (RBAC with Pundit)

---

## 🧰 Developer Experience

- RuboCop for linting and auto‑correct (`rubocop -A`)
- VS Code + Ruby LSP extension for linting/formatting/IntelliSense
- Pre‑commit hook to run RuboCop and/or test suite
- Clean Git history with feature branches and PRs to `dev` before merging to `main`

---

## 📌 Roadmap

- [ ] Profile enrichment (bio, contact info, profile picture + upload)
- [ ] Categories, tags, and geolocation for listings (map/near‑me)
- [ ] Messaging + notifications (email/in‑app)
- [ ] Background jobs with Sidekiq (image processing, notifications)
- [ ] Caching & performance optimization
- [ ] Analytics (views, inquiries, conversions)
- [ ] Mobile app integration (React Native / Flutter)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m "Add some feature"`
4. Push branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## 📜 License

This project is licensed under the **MIT License**.
