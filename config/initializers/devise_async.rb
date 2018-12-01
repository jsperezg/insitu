# frozen_string_literal: true

# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox, :backburner, :que, :sucker_punch
Devise::Async.enabled = true
Devise::Async.backend = :sidekiq
Devise::Async.queue = :urgent
