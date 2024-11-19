# lib/tasks/create_default_lists.rake
namespace :user do
    desc "Create default lists for existing users"
    task create_default_lists: :environment do
        User.find_each do |user|
            if user.lists.empty?
                user.lists.create(name: "行きたい", default: true)
                user.lists.create(name: "行った", default: true)
                puts "デフォルトリストを作成しました: #{user.email}"
            else
                puts "既にリストが存在します: #{user.email}"
            end
        end
    end
end
