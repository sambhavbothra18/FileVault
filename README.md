# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

# FileVault

FileVault is a personal file upload and sharing application built with Ruby on Rails. It allows users to upload files, manage them privately, and generate public shareable links for selected files.

---

## ✨ Features

- User authentication using Devise
- Secure private file listing per user
- File upload with title, description, and type detection
- Active Storage support with image previews
- File deletion support
- Optional file compression (up to 1GB)
- Public sharing via tiny URLs
- Background job handling with Sidekiq
- Redis integration (for background jobs)
- Built-in support for SQLite (development)

---

## 🛠️ Built With

- [Ruby 3.2.2](https://www.ruby-lang.org/)
- [Rails 7.1.3](https://rubyonrails.org/)
- [SQLite3](https://sqlite.org/) – default for development
- [Devise](https://github.com/heartcombo/devise) – user authentication
- [Active Storage](https://edgeguides.rubyonrails.org/active_storage_overview.html) – file uploads and previews
- [Sidekiq](https://sidekiq.org/) – background job processing
- [Redis](https://redis.io/) – required for Sidekiq
- [Importmap + Turbo + Stimulus](https://hotwired.dev/) – for modern frontend interactivity

---

## ⚙️ Setup Instructions

### 1. Clone the Repository

```bash
git clone git@github.com:sambhavbothra18/FileVault.git
cd FileVault

Install Dependencies
bundle install

Set Up the Database
bin/rails db:setup

Run the Application
bin/rails server

Visit http://localhost:3000 in your browser.

Author
Sambhav Bothra
GitHub: @sambhavbothra18
