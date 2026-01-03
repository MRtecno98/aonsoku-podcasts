#!/bin/sh
set -e

case "$CONTAINER_ROLE" in
    app)
        echo "🚀 [APP] Running startup tasks..."

        echo "📂 Publishing Filament assets..."
        php artisan filament:assets

        echo "📦 Running migrations..."
        php artisan migrate --force

        echo "👤 Seeding default user..."
        php artisan db:seed

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
        ;;
    worker)
        echo "⏳ [WORKER] Waiting for the App to start..."
        sleep 10
        echo "🚴 Starting the queue worker..."
        exec php artisan queue:work --sleep=5 --tries=3 --max-time=3600
        ;;
    scheduler)
        echo "⏰ [SCHEDULER] Starting the scheduler..."
        exec php artisan schedule:work
        ;;
    *)
        echo "❌ [ERROR] Invalid CONTAINER_ROLE: $CONTAINER_ROLE"
        exit 1
        ;;
esac
