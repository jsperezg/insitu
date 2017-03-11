namespace :insitu do
  desc "Remove user. Previously validates that the given user didn't connected during the last 7 days."
  task :drop_user, [:email] => [:environment] do |t, args|
    user = User.find_by(email: args[:email])
    if user.nil?
      puts "User #{ args[:email]} do not exists."
    else
      if user.current_sign_in_at.nil? or user.current_sign_in_at < DateTime.now - 7.days and user.payments.empty?
        user.destroy
        puts "User #{ args[:email]} deleted."
      else
        puts "User #{ args[:email]} is still active and won't be deleted."
      end
    end
  end

end
