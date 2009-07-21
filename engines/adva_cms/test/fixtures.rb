# empty the database
ActiveRecord::Base.connection.tables.each do |table_name|
  ActiveRecord::Base.connection.execute "DELETE FROM #{table_name}" unless table_name == 'schema_migrations'
end

# USERS

anonymous    = User.create! :first_name => 'an anonymous',
                            :email => 'an-anonymous@example.com',
                            :password => 'a password',
                            :verified_at => Time.now,
                            :anonymous => true

user         = User.create! :first_name => 'a user',
                            :email => 'a-user@example.com',
                            :password => 'a password',
                            :verified_at => Time.now

superuser    = User.create! :first_name => 'a superuser',
                            :email => 'a-superuser@example.com',
                            :password => 'a password',
                            :verified_at => Time.now

admin        = User.create! :first_name => 'an admin',
                            :email => 'an-admin@example.com',
                            :password => 'a password',
                            :verified_at => Time.now

moderator    = User.create! :first_name => 'a moderator',
                            :email => 'a-moderator@example.com',
                            :password => 'a password',
                            :verified_at => Time.now

               User.create! :first_name => 'an unverified user',
                            :email => 'a-unverified-user@example.com',
                            :password => 'a password'

# SITES

site         = Site.create! :name => 'site with pages',
                            :title => 'site with pages title',
                            :host => 'site-with-pages.com'

another_site = Site.create! :name => 'another site',
                            :title => 'another site title',
                            :host => 'another-site.com'

# SECTIONS

page =         Page.create! :site => site,
                            :title => 'a page',
                            :permalink => 'a-page',
                            :comment_age => 0,
                            :published_at => Time.parse('2008-01-01 12:00:00')

page.single_article_mode = false # FIXME make has_options monkeypatch upate_attributes
page.save!

               Page.create! :site => site,
                            :title => 'another page',
                            :permalink => 'another-page',
                            :comment_age => 0,
                            :published_at => Time.parse('2008-01-01 12:00:00')

               Page.create! :site => another_site,
                            :title => "another site's page",
                            :permalink => 'another-sites-page',
                            :comment_age => 0,
                            :published_at => Time.parse('2008-01-01 12:00:00')

category = Category.create! :section => page,
                            :title => 'a category'

unpublished_section = Page.create! :site => site,
                            :title => 'an unpublished section',
                            :permalink => 'an-unpublished-section',
                            :single_article_mode => false

# ARTICLES

article   = Article.create! :site => site,
                            :section => page,
                            :title => 'a page article',
                            :excerpt => 'a page article excerpt',
                            :body => 'a page article body',
                            :categories => [category],
                            :tag_list => 'foo bar',
                            :author => user,
                            :published_at => Time.parse('2008-01-01 12:00:00')

            Article.create! :site => site,
                            :section => page,
                            :title => 'an unpublished page article',
                            :body => 'an unpublished page article body',
                            :categories => [category],
                            :tag_list => 'foo bar',
                            :author => user

            Article.create! :site => site,
                            :section => unpublished_section,
                            :title => 'an article in an unpublished section',
                            :body => 'an article in an unpublished section',
                            :author => user

attributes = { :site => site, :section => page, :commentable => article, :author => user }
Comment.create! attributes.merge(:body => 'the approved comment body', :approved => 1)
Comment.create! attributes.merge(:body => 'the unapproved comment body',:approved => 0)

# ROLES and MEMBERSHIPS

superuser.roles.create!(:name => 'superuser')
admin.roles.create!(:name => 'admin', :context => site)
moderator.roles.create!(:name => 'moderator', :context => page)

site.users << user
site.users << superuser
site.users << admin
site.users << moderator

# OTHERS

CachedPage.create! :site_id => site.id,
                   :section_id => page.id,
                   :url => "http://#{site.host}"
