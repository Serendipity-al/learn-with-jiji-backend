# Learn with Jiji - Backend API

AI-driven learning companion backend service built with Node.js, Express, and Supabase.

##  Features

- RESTful API for AI learning queries
- Supabase integration (Database, Auth, Storage, RLS)
- Mocked AI responses with resource matching
- Row Level Security (RLS) implementation
- Clean error handling and validation

##  Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage

##  Prerequisites

- Node.js (v14 or higher)
- Supabase account
- npm or yarn

##  Installation & Setup

### 1. Clone the repository
```bash
git clone <your-repo-url>
cd learn-with-jiji-backend
```

### 2. Install dependencies
```bash
npm install
```

### 3. Environment Configuration

Create a `.env` file in the root directory:
```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_role_key
PORT=3000
```

### 4. Database Setup

Run the SQL schema provided in `schema.sql` in your Supabase SQL Editor.

### 5. Run the server
```bash
# Development mode
npm run dev

# Production mode
npm start
```

Server will start on `http://localhost:3000`

##  API Endpoints

### Health Check
```http
GET /
```

**Response:**
```json
{
  "message": "Learn with Jiji API is running!",
  "status": "healthy",
  "timestamp": "2026-02-10T08:28:07.290Z"
}
```

### Ask Jiji (Main Endpoint)
```http
POST /ask-jiji
```

**Request Body:**
```json
{
  "query": "Explain RAG",
  "user_id": "550e8400-e29b-41d4-a716-446655440000"
}
```

**Response:**
```json
{
  "success": true,
  "query_id": "uuid",
  "answer": "RAG (Retrieval-Augmented Generation) is...",
  "resources": [
    {
      "id": "uuid",
      "title": "Introduction to RAG",
      "type": "ppt",
      "description": "Learn about RAG...",
      "url": "https://..."
    }
  ],
  "timestamp": "2026-02-10T08:28:32.142Z"
}
```

### Get All Resources
```http
GET /resources
```

##  Authentication & Security

### Row Level Security (RLS)

All tables have RLS enabled:

- **profiles**: Users can only view/update their own profile
- **queries**: Users can only view/insert their own queries
- **resources**: Public read access, authenticated insert

### Security Features

- ✅ No secrets in code (environment variables)
- ✅ Input validation on API endpoints
- ✅ Row Level Security policies
- ✅ Service role key for backend operations
- ✅ CORS enabled for frontend integration

##  Database Schema

### Tables

1. **profiles**
   - id (UUID, Primary Key)
   - email (TEXT, Unique)
   - full_name (TEXT)
   - avatar_url (TEXT)
   - created_at, updated_at (TIMESTAMP)

2. **queries**
   - id (UUID, Primary Key)
   - user_id (UUID, Foreign Key → profiles)
   - query_text (TEXT)
   - created_at (TIMESTAMP)

3. **resources**
   - id (UUID, Primary Key)
   - title (TEXT)
   - description (TEXT)
   - resource_type (TEXT: 'ppt', 'video', 'document')
   - file_url (TEXT)
   - thumbnail_url (TEXT)
   - tags (TEXT)
   - created_by (UUID, Foreign Key → profiles)
   - created_at, updated_at (TIMESTAMP)

##  Testing

### Using cURL
```bash
# Health check
curl http://localhost:3000/

# Ask Jiji
curl -X POST http://localhost:3000/ask-jiji \
  -H "Content-Type: application/json" \
  -d '{"query":"Explain RAG","user_id":"550e8400-e29b-41d4-a716-446655440000"}'
```

### Using Postman

1. Import the collection (if provided)
2. Set base URL to `http://localhost:3000`
3. Test endpoints

##  How It Works

1. **User sends query** → Frontend calls `POST /ask-jiji`
2. **Backend validates** → Checks query and user_id
3. **Store query** → Saves to `queries` table
4. **Search resources** → Matches keywords in `resources` table
5. **Generate response** → Returns mocked AI answer + matching resources
6. **Frontend renders** → Displays answer and resource links

## Future Improvements (Given More Time)

1. **Real AI Integration**: Integrate with OpenAI/Anthropic API for actual AI responses
2. **Vector Search**: Implement semantic search using embeddings (pgvector)
3. **Caching**: Add Redis for frequently asked queries
4. **Rate Limiting**: Implement rate limiting per user
5. **Analytics**: Track popular queries and resources
6. **File Upload**: Allow users to upload their own learning materials
7. **Real-time**: WebSocket support for streaming AI responses
8. **Authentication**: Full JWT-based auth with signup/login
9. **Testing**: Unit and integration tests
10. **Docker**: Containerize the application

##  Project Structure
```
learn-with-jiji-backend/
├── server.js           # Main application file
├── package.json        # Dependencies
├── .env               # Environment variables (not in git)
├── .gitignore         # Git ignore rules
├── README.md          # This file
└── schema.sql         # Database schema
```

## 👤 Author

**Your Name**
- LinkedIn: [Your LinkedIn]
- GitHub: [Your GitHub]

##  Contact

For any queries regarding this assignment, contact: hello@veidalabs.com

---

**Built for VeidaLabs Software Developer Hiring Assignment**