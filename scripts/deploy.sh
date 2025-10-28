#!/bin/bash
# Multi-Environment Deployment Script
# Supports Production and Development modes
# Version: 1.0.0 (Production), 2.0.0-beta (Development)

set -e

# Default to production if not specified
DEPLOY_ENV=${DEPLOY_ENV:-production}

echo "====================================="
echo "DevOps Simulator - Deployment"
echo "====================================="

if [ "$DEPLOY_ENV" = "production" ]; then
    echo "Mode: Production"
    DEPLOY_REGION="us-east-1"
    APP_PORT=8080
    ENABLE_DEBUG=false

    echo "Environment: $DEPLOY_ENV"
    echo "Region: $DEPLOY_REGION"
    echo "Port: $APP_PORT"
    echo "Debug: $ENABLE_DEBUG"

elif [ "$DEPLOY_ENV" = "development" ]; then
    echo "Mode: Development"
    DEPLOY_MODE="docker-compose"
    APP_PORT=3000
    ENABLE_DEBUG=true

    echo "Environment: $DEPLOY_ENV"
    echo "Mode: $DEPLOY_MODE"
    echo "Port: $APP_PORT"
    echo "Debug: $ENABLE_DEBUG"

else
    echo "Error: Unknown environment $DEPLOY_ENV"
    exit 1
fi

# Pre-deployment checks
echo "Running pre-deployment checks..."
if [ ! -f "config/app-config.yaml" ]; then
    echo "Error: Configuration file not found!"
    exit 1
fi

# Environment-specific deployment steps
if [ "$DEPLOY_ENV" = "production" ]; then
    # Production deployment
    echo "Starting production deployment..."
    echo "Pulling latest Docker images..."
    # docker pull devops-simulator:latest

    echo "Rolling update strategy initiated..."
    # kubectl rolling-update devops-simulator

    echo "Production deployment completed successfully!"
    echo "Application available at: https://app.example.com"

elif [ "$DEPLOY_ENV" = "development" ]; then
    # Development deployment
    echo "Installing dependencies..."
    npm install

    echo "Running tests..."
    npm test

    echo "Starting development deployment..."
    echo "Using Docker Compose..."
    docker-compose up -d

    # Wait for application to start
    echo "Waiting for application to be ready..."
    sleep 5

    # Health check
    echo "Performing health check..."
    curl -f http://localhost:$APP_PORT/health || exit 1

    echo "Development deployment completed successfully!"
    echo "Application available at: http://localhost:$APP_PORT"
    echo "Hot reload enabled - code changes will auto-refresh"
fi