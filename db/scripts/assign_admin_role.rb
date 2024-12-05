user = User.find_by(email: "kuppyramune315@gmail.com")
if user
    user.update(role: "admin")
    puts "Admin role successfully assigned to user with email: #{user.email}"
else
    puts "User not found with email: kuppyramune315@gmail.com"
end
