# Stage 1: Builder
FROM ruby:3.2-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config --global frozen 1 && \
    bundle install --jobs 4 --retry 3

# Stage 2: Production
FROM ruby:3.2-alpine AS production

# Install runtime dependencies
RUN apk add --no-cache \
    postgresql-client \
    tzdata

# Create app user
RUN addgroup -g 1000 -S app && \
    adduser -u 1000 -S app -G app

# Set working directory
WORKDIR /app

# Copy gems from builder stage
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Copy application code
COPY --chown=app:app . .

# Switch to app user
USER app

# Expose port
EXPOSE 3000

# Default command
CMD ["rails", "server", "-b", "0.0.0.0"]# Stage 3: 
Development
FROM builder AS development

# Install additional development tools
RUN apk add --no-cache \
    postgresql-client \
    tzdata \
    curl

# Set working directory
WORKDIR /app

# Copy application code
COPY . .

# Create directories for volumes
RUN mkdir -p tmp/pids tmp/cache tmp/sockets log

# Expose port
EXPOSE 3000

# Default command for development
CMD ["rails", "server", "-b", "0.0.0.0"]