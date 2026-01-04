#!/bin/sh

show_usage() {
    echo "Usage: $0 {queue|scheduler}"
    exit 1
}

# Check if an argument was provided
if [ -z "$1" ]; then
    show_usage
fi

case "$1" in
    queue)
        echo "⏳ [WORKER] Waiting for the App to start..."
        sleep 10
        echo "🚴 Starting the queue worker..."
        exec php artisan queue:work --sleep=5 --tries=3 --max-time=2400
        ;;
    scheduler)
        echo "⏰ [SCHEDULER] Starting the scheduler..."
        exec php artisan schedule:work
        ;;
    *)
        echo "❌ Invalid command!"
        show_usage
        ;;
esac

