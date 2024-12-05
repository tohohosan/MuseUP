set -o errexit

yarn install --check-files
yarn build:css

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate