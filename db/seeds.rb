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
Post.delete_all




# Create users
#
users = []
for i in 0..100 do
  User.create! :nickname => 'user_'+i.to_s, :email => 'user_'+i.to_s+'@gmail.com', :password => 'User____' +i.to_s, :password_confirmation => 'User____' +i.to_s
end


# Create posts and relative comments
for i in 0..50 do
  p = Post.create! :title => 'Some Title '+i.to_s, :text => 'Some Text D'+i.to_s
  for j in 0..3 do
    c = Comment.create! :body => "Some comment for post "+i.to_s+", comment number "+j.to_s, :post => p
  end
end

