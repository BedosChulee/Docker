-- PostgreSQL Database Initialization Script
-- This script creates the required tables and sets up the database schema

-- Create users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create posts table with foreign key relationship to users
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_created_at ON posts(created_at);


-- Insert sample users
INSERT INTO users (name, email, created_at, updated_at) VALUES
    ('Alice Johnson', 'alice.johnson@example.com', '2024-01-15 10:30:00', '2024-01-15 10:30:00'),
    ('Bob Smith', 'bob.smith@example.com', '2024-01-20 14:45:00', '2024-01-20 14:45:00'),
    ('Carol Davis', 'carol.davis@example.com', '2024-01-25 09:15:00', '2024-01-25 09:15:00');

-- Insert sample posts with proper user associations
INSERT INTO posts (title, content, user_id, created_at, updated_at) VALUES
    ('Getting Started with PostgreSQL', 'PostgreSQL is a powerful, open source object-relational database system. In this post, I''ll share my experience setting it up for the first time.', 1, '2024-01-16 11:00:00', '2024-01-16 11:00:00'),
    ('Docker Best Practices', 'Here are some essential Docker best practices I''ve learned over the years. These tips will help you create more efficient and secure containers.', 1, '2024-01-18 15:30:00', '2024-01-18 15:30:00'),
    ('Database Design Principles', 'Good database design is crucial for application performance. Let me walk you through the key principles I follow when designing database schemas.', 2, '2024-01-21 10:15:00', '2024-01-21 10:15:00'),
    ('Introduction to SQL Joins', 'SQL joins can be confusing at first, but they''re essential for working with relational databases. This post covers the different types of joins with examples.', 2, '2024-01-22 16:45:00', '2024-01-22 16:45:00'),
    ('Web Development Trends 2024', 'The web development landscape is constantly evolving. Here are the trends I''m watching closely this year and how they might impact our projects.', 3, '2024-01-26 12:20:00', '2024-01-26 12:20:00'),
    ('Debugging Tips and Tricks', 'Debugging is an art form. Over the years, I''ve collected various techniques that have saved me countless hours. Here are my favorites.', 1, '2024-01-27 14:10:00', '2024-01-27 14:10:00'),
    ('API Design Guidelines', 'Creating well-designed APIs is essential for modern applications. This post outlines the guidelines I follow when designing RESTful APIs.', 2, '2024-01-28 09:30:00', '2024-01-28 09:30:00'),
    ('Performance Optimization Strategies', 'Application performance can make or break user experience. Here are proven strategies I use to optimize both frontend and backend performance.', 3, '2024-01-29 11:45:00', '2024-01-29 11:45:00'),
    ('Testing Methodologies', 'Testing is not just about finding bugs; it''s about building confidence in your code. Let me share the testing methodologies that work best for me.', 1, '2024-01-30 13:25:00', '2024-01-30 13:25:00'),
    ('Deployment Automation', 'Manual deployments are error-prone and time-consuming. In this post, I''ll show you how to set up automated deployment pipelines that save time and reduce errors.', 3, '2024-01-31 16:00:00', '2024-01-31 16:00:00');