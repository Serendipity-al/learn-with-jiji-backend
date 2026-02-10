-- ============================================
-- Learn with Jiji - Database Schema
-- VeidaLabs Assignment
-- ============================================

-- Create profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create queries table
CREATE TABLE queries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  query_text TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create resources table
CREATE TABLE resources (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  resource_type TEXT CHECK (resource_type IN ('ppt', 'video', 'document')),
  file_url TEXT,
  thumbnail_url TEXT,
  tags TEXT,
  created_by UUID REFERENCES profiles(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- Enable Row Level Security (RLS)
-- ============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE queries ENABLE ROW LEVEL SECURITY;
ALTER TABLE resources ENABLE ROW LEVEL SECURITY;

-- ============================================
-- RLS Policies for profiles
-- ============================================

CREATE POLICY "Users can view their own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

-- ============================================
-- RLS Policies for queries
-- ============================================

CREATE POLICY "Users can view their own queries"
  ON queries FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own queries"
  ON queries FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- RLS Policies for resources
-- ============================================

CREATE POLICY "Anyone can view resources"
  ON resources FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can insert resources"
  ON resources FOR INSERT
  TO authenticated
  WITH CHECK (true);

-- ============================================
-- Sample Data
-- ============================================

-- Insert sample user profile
INSERT INTO profiles (id, email, full_name) VALUES
  ('550e8400-e29b-41d4-a716-446655440000', 'demo@jiji.com', 'Demo User');

-- Insert sample resources
INSERT INTO resources (title, description, resource_type, file_url, tags) VALUES
  (
    'Introduction to RAG',
    'Learn about Retrieval-Augmented Generation and how it improves AI responses',
    'ppt',
    'https://example.com/rag-intro.ppt',
    'rag, ai, retrieval, generation'
  ),
  (
    'RAG Implementation Tutorial',
    'Step-by-step video guide on implementing RAG systems',
    'video',
    'https://example.com/rag-tutorial.mp4',
    'rag, tutorial, implementation'
  ),
  (
    'Understanding LLMs',
    'Comprehensive guide to Large Language Models',
    'ppt',
    'https://example.com/llm-guide.ppt',
    'llm, language models, ai'
  ),
  (
    'Prompt Engineering Basics',
    'Learn how to write effective prompts for AI models',
    'video',
    'https://example.com/prompt-engineering.mp4',
    'prompt, engineering, ai'
  );

-- ============================================
-- Performance Indexes
-- ============================================

CREATE INDEX idx_queries_user_id ON queries(user_id);
CREATE INDEX idx_queries_created_at ON queries(created_at DESC);
CREATE INDEX idx_resources_type ON resources(resource_type);
CREATE INDEX idx_resources_created_at ON resources(created_at DESC);

-- ============================================
-- Comments for Documentation
-- ============================================

COMMENT ON TABLE profiles IS 'User profiles for Learn with Jiji platform';
COMMENT ON TABLE queries IS 'User queries and search history';
COMMENT ON TABLE resources IS 'Learning resources (PPT, videos, documents)';

COMMENT ON COLUMN resources.resource_type IS 'Type of resource: ppt, video, or document';
COMMENT ON COLUMN resources.tags IS 'Comma-separated tags for search matching';
