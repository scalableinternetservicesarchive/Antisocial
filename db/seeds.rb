# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
# #user = "User.create! :nickname => 'user__ID', :email => 'user__ID@gmail.com', :password => 'User__PASSWORD', :password_confirmation => 'User__PASSWORD'"
# users = []
# for i in range(100):
#     users.append(user.replace('_ID', str(i)).replace('_PASSWORD', str(i)*5))
#
# for i in users:
#     print(i)
#
#
# post = "Post.create! :title => 'Some Title __ID', :text => 'Some Text __ID'"
# posts = []
#
# for i in range(100):
#     posts.append(post.replace('_ID', str(i)))
#
#
# for i in posts:
#     print(i)
#



User.delete_all
Comment.delete_all
Post.delete_all
Friendship.delete_all



# Create users
#
puts "Starting users generation..."
users = []
for i in 0..1000 do
  u = (User.create! :nickname => 'user_'+i.to_s, :email => 'user_'+i.to_s+'@gmail.com', :password => 'Password1234', :password_confirmation => 'Password1234')
  users << u
end
puts "Users generation completed"
puts
puts "Starting profile generation"
for i in 0..100 do
  p = Profile.create! :first_name => "f_name" + i.to_s, :last_name => "l_name" + i.to_s, :address => "address" + i.to_s,:about =>"about" + i.to_s, :user_id => users[i].id
end
puts "Profiles generation completed"

puts
#Create posts and relative comments
puts "Starting post and comments generation..."
for i in 0..10000 do
  users_len = users.length()
  from = rand(0..users_len-1)
  p = Post.create! :title => 'Some Title '+i.to_s, :text => 'Some Text D'+i.to_s, :user_id => users[from].id
  for j in 0..10 do
    users_len = users.length()
    from = rand(0..users_len-1)
    c = Comment.create! :body => "Some comment for post "+i.to_s+", comment number "+j.to_s, :post => p, :user_id => users[from].id
  end
end

puts "Posts and comments generation completed!"
puts

#Comment.create! :user_id => users[from].id
#Post.create! :user_id => users[from].id

# Generate friendships
#
puts "Starting followship generation..."
for i in 0..100000
  users_len = users.length()
  from = rand(0..users_len-1)
  to = rand(0..users_len-1)
  while from.eql? to
    to = rand(0..users_len-1)
  end
  Friendship.create! :user_id => users[from].id, :friend_id => users[to].id, :friend => users[to]
end
puts "Followship generation completed!"
puts
