namespace :setup do
  desc 'copy sidekiq.yml file.'
  task :copy_sidekiq_yml do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read("config/sidekiq.yml")), "#{shared_path}/config/sidekiq.yml"
    end
  end
end

