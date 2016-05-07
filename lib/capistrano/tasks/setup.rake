namespace :setup do
  # desc 'copy paypal.yml file.'
  # task :copy_paypal_yml do
  #   on roles(:app) do
  #     execute "mkdir -p #{shared_path}/config"
  #     upload! StringIO.new(File.read("config/paypal.yml")), "#{shared_path}/config/paypal.yml"
  #   end
  # end
end

