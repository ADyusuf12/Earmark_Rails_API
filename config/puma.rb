# config/puma.rb

threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

workers ENV.fetch("WEB_CONCURRENCY", 1)

# Use Fly’s PORT env var (defaults to 8080 if not set)
port ENV.fetch("PORT") { 3000 }

plugin :tmp_restart
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

preload_app!
