🛠️ Rails API with JWT Authentication and User Profiles
This project is a Ruby on Rails API‑only application that provides user authentication with Devise + JWT and supports role‑based profiles through a UserProfile model.

🚀 Features
User registration and login with JWT authentication

Stateless sessions using devise-jwt

Automatic creation of a UserProfile for each user

Supported account types: customer (default), agent, developer, owner

Request specs and model specs with RSpec, FactoryBot, and Shoulda‑Matchers

📂 Project Structure
app/models/user.rb – Devise user model with JWT and profile callback

app/models/user_profile.rb – Profile model with account type validation

app/controllers/api/v1/registrations_controller.rb – Custom registration with profile handling

spec/requests/registrations_spec.rb – Request specs for registration

spec/models/user_spec.rb – User model specs

spec/models/user_profile_spec.rb – UserProfile model specs

spec/factories/ – Factories for users and profiles

🔑 Authentication Endpoints
Register: POST /api/v1/register

Creates a new user and profile (defaults to customer if no account_type provided).

Login: POST /api/v1/login

Returns a JWT access token and user data.

Logout: DELETE /api/v1/logout

Revokes the JWT token.

Responses include a JWT access token and user/profile data.

✅ Includes
Request specs for registration and profile creation

Model specs for associations, validations, and callbacks

🛠️ Setup
Clone the repo

git clone <your-repo-url>

cd <your-repo-folder>

Install dependencies

bundle install

Set up the database

rails db:create db:migrate

Run the server

rails s

🧪 Testing
Run the test suite with:

bundle exec rspec

This will run:

Request specs for registration and profile creation

Model specs for associations, validations, and callbacks

📌 Next Steps
Add role‑specific models (Agent, Developer, Owner)

Implement authorization (for example, Pundit or CanCanCan)

Expand API endpoints for profile management

🤝 Contributing
Fork the repository

Create a new branch

git checkout -b feature/your-feature

Commit your changes

git commit -m "Add some feature"

Push to the branch

git push origin feature/your-feature

Open a Pull Request

📜 License
This project is licensed under the MIT License.
