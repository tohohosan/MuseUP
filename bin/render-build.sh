set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

echo "Updating user role for admin user..."
bundle exec rails runner "load 'db/scripts/assign_admin_role.rb'"