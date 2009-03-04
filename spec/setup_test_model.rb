require 'rubygems'
require 'active_record'
require 'active_record/fixtures'
require 'factory_girl'

require File.expand_path("record_extention_test_util", File.dirname(__FILE__))
RecrodExtention::TestUtil.setup

class User < ActiveRecord::Base
  define_table do |t|
    t.string "name"
    t.timestamps
  end
  has_many :memberships
  has_many :groups, :through => :memberships
end

class Membership < ActiveRecord::Base
  define_table do |t|
    t.belongs_to :user
    t.belongs_to :group
  end
  belongs_to :user
  belongs_to :group
end

class Group < ActiveRecord::Base
  define_table do |t|
    t.string :name
  end
  has_many :memberships
  has_many :users, :through => :memberships

  has_many :accessibilities
  has_many :blogs, :through => :accessibilities
end

class Accessibility < ActiveRecord::Base
  define_table do |t|
    t.belongs_to :blog
    t.belongs_to :group
  end
  belongs_to :blog
  belongs_to :group
end

class Blog < ActiveRecord::Base
  define_table do |t|
    t.string   "title"
    t.boolean  "public"
    t.timestamps
  end
  has_many :accessibilities
  has_many :entries
end

class Entry < ActiveRecord::Base
  define_table do |t|
    t.string "title"
    t.text   "body"
    t.belongs_to "blog"
  end

  belongs_to :blog
  has_one :publication
end

class Publication < ActiveRecord::Base
  define_table do |t|
    t.timestamp :published_at
    t.belongs_to :entry
  end

  belongs_to :entry
end

Factory.define(:group) do |g|
  g.name "collaborators"
end

Factory.define(:accessibility) do |a|
  a.group{|g| g.association(:group) }
end

Factory.define(:blog) do |b|
  b.title "My Blog"
  b.public true
  b.accessibilities{|as| [Factory.build(:accessibility)] }
end

Factory.define(:user) do |u|
  u.name "alice"
end

Factory.define(:entry) do |e|
  e.title "My Entry"
  e.body  "!!! Body of the entry. !!!"
end

