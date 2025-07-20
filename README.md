Word Complexity Score API

This is a simple asynchronous Rails API that calculates a complexity score for each English word in a given list.

The score is based on data fetched from https://dictionaryapi.dev and is calculated as:
complexity_score = (number of synonyms + number of antonyms) / number of definitions

Example:

"Happy" has 8 synonyms, 2 antonyms, and 4 definitions, then score = (8 + 2) / 4 = 2.5

---

Technology Stack:

Ruby 3.4.1
Rails 8.0.2
PostgreSQL (used as main DB, using JSONB column to store result)
Sidekiq for background jobs
Redis (required for Sidekiq)
JSON API (no frontend)
Dictionary API: https://dictionaryapi.dev/

---

Setup Instructions:

1. Clone the project
git clone https://github.com/RailsEnjoyer/tech_interview_task
cd word-complexity-api

2.	Install dependencies
bundle

3.	Setup PostgreSQL database
rails db:create db:migrate

4.	Start Redis
redis-server

5. Start Sidekiq 
bundle exec sidekiq

6.	Run the Rails server
rails s

---

API Usage

POST /api/complexity-score
for example: 
curl -X POST http://localhost:3000/api/complexity-score \
     -H "Content-Type: application/json" \
     -d '["happy", "sad", "joyful]' 

Submits a list of words to calculate their complexity scores in the background.

response: { "job_id": "your-job-id" }

GET /api/complexity-score/:your-job-id

Returns the status of the processing job and the final scores once completed.

response (when in progress):
{ "status": "pending" }


response (completed):
{
  "status": "completed",
  "result": {
    "sad": 1.8,
    "happy": 3,
    "joyful": 0
  }
}


Notes:

- Results are stored in a PostgreSQL jsonb field for efficient and flexible querying.
- Sidekiq queues used: default, synonyms, antonyms, definitions.
- For demonstration purposes, a small artificial delay (sleep 15) is added in the main job to make the "pending" status observable via GET requests.