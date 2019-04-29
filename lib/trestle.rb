require "trestle/version"

require "active_support/all"

require "sass-rails"
require "autoprefixer-rails"
require "kaminari"

module Trestle
  extend ActiveSupport::Autoload

  autoload :Adapters
  autoload :Admin
  autoload :Attribute
  autoload :Breadcrumb
  autoload :Builder
  autoload :Configurable
  autoload :Configuration
  autoload :Display
  autoload :EvaluationContext
  autoload :Form
  autoload :Hook
  autoload :ModelName
  autoload :Navigation
  autoload :Options
  autoload :Reloader
  autoload :Resource
  autoload :Scopes
  autoload :Tab
  autoload :Table
  autoload :Toolbar
  autoload :Actor

  mattr_accessor :admins
  self.admins = {}

  def self.admin(name, options={}, &block)
    register(Admin::Builder.create(name, options, &block))
  end

  def self.resource(name, options={}, &block)
    register(Resource::Builder.create(name, options, &block))
  end

  def self.register(admin)
    if actor = admin.find_actor
      reg = Actor.admins_registry(actor.id)
    else
      reg = self.admins
    end
    reg[admin.admin_name] = admin

    # self.admins[admin.admin_name] = admin
  end

  def self.lookup(admin)
    return admin if admin.is_a?(Class) && admin < Trestle::Admin
    self.admins[admin.to_s]
  end

  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure(&block)
    config.configure(&block)
  end

  def self.navigation(context)
    blocks = config.menus + admins.values.map(&:menu).compact
    Navigation.build(blocks, context)
  end

  #########################################################
  # actor based admin extension
  # eg. developer actor console pages
  
  mattr_accessor :actors_admins
  self.actors_admins = {}

  def self.actor_navigation(context, actor_id)
    adms = Actor.admins_registry(actor_id)
    menus = adms.values.map(&:menu).compact
    Navigation.build(menus, context)
  end
end

require "trestle/engine" if defined?(Rails)
