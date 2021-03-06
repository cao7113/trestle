Trestle::Engine.routes.draw do
  Trestle.admins.each do |name, admin|
    instance_eval(&admin.routes)
  end

  # multi-actors support
  Trestle.actors_admins.each do |actor, admins|
    admins.each do |name, admin|
      instance_eval(&admin.routes)
    end
  end

  root to: "trestle/dashboard#index"
end
