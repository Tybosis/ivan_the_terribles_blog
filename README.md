# Security Fixes

My first step to fixing the security problems was to install brakeman
and run a security analysis of the program.  Only two errors came back,
one for a dynamic render path, and one for having a secret key in
a file that was checked in to version control.  The dynamic render
problem is one where a user can gain access to templates that they should
not have access to.  So to fix this problem, rather than render a post
partial, I switched the post index page to load all the posts with an
each loop.

app/views/posts/index.html.erb
```ruby
<% @posts.each do |post| %>
  <%= content_tag :section, class: "post #{post.publish_status}" do %>
    <h2>Post <%= "#{post.id}: #{post.title}" %></h2>
    <div class="post"><%= post.body %></div>
    <%= render 'post_nav', post: post %>
    <%#= render post.comments %>
  <% end %>
<% end %>
```

Next, to fix the secret key problem, I moved the key into a separate file
which I added to the .gitignore file, and then loaded that secret key
into the environment by reading it from the new file.

app/config/initializers/secret_token.rb
```ruby
begin
  IvanTheTerriblesBlog::Application.configure do
    config.secret_token = File.read(Rails.root.join('secret_token.rb'))
  end
rescue LoadError, Errno::ENOENT => e
  raise "Secret token couldn't be loaded! Error: #{e}"
end
```
Finally, I changed the search method in the post model to not use what
the user typed in directly in the SQL command, to try and avoid SQL
injection attacks.  I accomplished this by adding a question mark to
the search string, and then extracting what the user actually typed
in to the search box.  This syntax allows rails to do its own SQL
scrubbing.

```ruby
def self.search(search)
  if search
    search.strip
    includes(comments: :replies).where("title like ?", "%#{search}%")
  else
    includes(comments: :replies).order("updated_at DESC")
  end
end
```

I also checked to make sure the program had the right whitelisted
parameters, I checked which attribues were accessible in the model
(attr_accessible), I made sure that protect_from_forgery was included
in the application_controller, and I made sure that the password
parameters were being properly filtered.
