#!/bin/sh
set -e

if [ "$CONTAINER_ROLE" == "app" ]; then
    echo "🚀 [APP] Running startup tasks..."

    echo "📂 Publishing Filament assets..."
    php artisan filament:assets

    echo "📦 Running migrations..."
    php artisan migrate --force

    echo "👤 Seeding default user..."
    php artisan db:seed --force

    echo "📚 Generating API docs"
    php artisan scribe:generate

    echo "🔗 Creating storage symlink..."
    php artisan storage:link

    if [ "$APP_ENV" != "local" ]; then
        echo "🔥 Caching configuration for Production..."
        php artisan config:cache
        php artisan route:cache
        php artisan view:cache
    else
        echo "🧹 Clearing caches for Local Development..."
        php artisan config:clear
        php artisan route:clear
        php artisan view:clear
    fi
fi
