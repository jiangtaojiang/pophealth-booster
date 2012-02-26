PopHealth::Application.routes.draw do

  devise_for :users, :controllers => {:registrations => "registrations"}

  get "admin/users"
  post "admin/promote"
  post "admin/demote"
  post "admin/approve"
  post "admin/disable"
  post "admin/update_npi"

  get "logs/index"
  
  match 'measures', :to => 'measures#index', :as => :dashboard, :via => :get
  match "measure/:id(/:sub_id)/providers", :to => "measures#providers", :via => :get
  match 'measure/:id(/:sub_id)', :to => 'measures#show', :as => :measure, :via => :get
  match 'measures/result/:id(/:sub_id)', :to => 'measures#result', :as => :measure_result, :via => :get
  match 'measures/definition/:id(/:sub_id)', :to => 'measures#definition', :as => :measure_definition, :via => :get
  match 'measures/patients/:id(/:sub_id)', :to => 'measures#patients', :as => :patients, :via => :get
  match 'measure/:id/select', :to => 'measures#select', :as => :select, :via => :post
  match 'measure/:id/remove', :to => 'measures#remove', :as => :remove, :via => :post
  match 'measures/measure_patients/:id(/:sub_id)', :to=>'measures#measure_patients', :as => :measure_patients, :via=> :get
  match 'measures/measure_report', :to=>'measures#measure_report', :as => :measure_report, :via=> :get
  match 'measures/patient_list/:id(/:sub_id)', :to=>'measures#patient_list', :as => :patient_list, :via=> :get
  match 'measures/period', :to=>'measures#period', :as => :period, :via=> :post
  
  match 'provider/:npi', :to => "measures#index", :as => :provider_dashboard, :via => :get
  
  match 'records', :to => 'records#create', :via => :post
  
  match 'patients', :to => 'patients#index', :via => :get
  match 'patients/show/:id', :to => 'patients#show'
  match 'patients/toggle_excluded/:id/:measure_id(/:sub_id)', :to => 'patients#toggle_excluded', :via => :post

  match 'providers/measure/:measure_id(/:sub_id)', :to => "providers#measure", :as => :providers_measure, :via => :get 
  
  root :to => 'measures#index'
  
#####booster#############

  match 'admin/patients' => 'admin#admin_patients', :as => :admin_patients, :via => :get
  match 'admin/patients/random' => 'admin#randomize_patients', :as => :randomize_patients, :via => :get
  match 'admin/patients/random/hbv' => 'admin#randomize_hbvs', :as => :randomize_hbvs, :via => :get
  match 'admin/patients/random/hcv' => 'admin#randomize_hcvs', :as => :randomize_hcvs, :via => :get
  match 'admin/patients/clear' => 'admin#clear_patients', :as => :clear_patients, :via => :get

    match 'equity', :to => 'equity#index', :as => :report_equity, :via => :get
    match 'equity/:cdn_id/:eqm_id', :to => 'equity#show_patients', :as => :show_equity_patients, :via => :get
    match 'equity/help', :to => 'equity#help', :as => :equity_help, :via => :get
    match 'equity/demo', :to => 'equity#demo', :as => :equity_demo, :via => :get
  
    match 'eqpatients', :to => 'eqpatients#index', :as => :list_patients, :via => :get
    match 'eqpatients/find', :to => 'eqpatients#index', :as => :find_patients, :via => :post
    match 'eqpatients/new', :to => 'eqpatients#new', :as => :new_patient, :via => :get
    match 'eqpatients/create', :to => 'eqpatients#create', :as => :create_patient, :via => :post
    match 'eqpatients/:id' => 'eqpatients#show', :as => :show_patient, :via => :get
    match 'eqpatients/:id/edit' => 'eqpatients#edit', :as => :edit_patient, :via => :get
    match 'eqpatients/:id/update' => 'eqpatients#update', :as => :update_patient, :via => :post
    match 'eqpatients/:id/delete', :to => 'eqpatients#destroy', :as => :delete_patient, :via => :get
  
    match 'profiles/:id/edit' => 'profiles#edit', :as => :edit_patient_profile, :via => :get
    match 'profiles/:id/update' => 'profiles#update', :as => :update_patient_profile, :via => :post
  
    match 'conditions/:id/new' => 'eqconditions#new', :as => :new_condition, :via => :get
    match 'conditions/:id/create' => 'eqconditions#create', :as => :create_condition, :via => :post
    match 'conditions/edit/:id/:cdn_id' => 'eqconditions#edit', :as => :edit_condition, :via => :get
    match 'conditions/update/:id/:cdn_id' => 'eqconditions#update', :as => :update_condition, :via => :post
    match 'conditions/remove/:id/:cdn_id' => 'eqconditions#destroy', :as => :remove_condition, :via => :get
  
    match 'conditions/vaccine/add/:id/:cdn_id' => 'eqconditions#add_vaccine', :as => :add_condition_vaccine, :via => :post
    match 'conditions/vaccine/remove/:id/:cdn_id/:vac_id' => 'eqconditions#remove_vaccine', :as => :remove_condition_vaccine, :via => :get
  
    match 'conditions/treatment/add/:id/:cdn_id' => 'eqconditions#add_treatment', :as => :add_condition_treatment, :via => :post
    #match 'conditions/treatment/update/:id/:cdn_id/:tr_id' => 'eqconditions#update_treatment', :as => :update_condition_treatment, :via => :post
    match 'conditions/treatment/remove/:id/:cdn_id/:tr_id' => 'eqconditions#remove_treatment', :as => :remove_condition_treatment, :via => :get
  
    match 'conditions/hbv/update/:id/:cdn_id' => 'hbvs#update', :as => :update_hbv, :via => :post
    match 'conditions/hbv/monitor/add/:id/:cdn_id' => 'hbvs#add_test', :as => :add_hbv_test, :via => :post
    match 'conditions/hbv/monitor/update/:id/:cdn_id/:dx_id' => 'hbvs#update_test', :as => :update_hbv_test, :via => :post
    match 'conditions/hbv/monitor/remove/:id/:cdn_id/:dx_id' => 'hbvs#remove_test', :as => :remove_hbv_test, :via => :get
  
    match 'conditions/hcv/update/:id/:cdn_id' => 'hcvs#update', :as => :update_hcv, :via => :post 
 
#####end booster##############  
  
  resources :measures do
    member { get :providers }
  end
  
  resources :providers do
    resources :patients do
      collection do
        get :manage
        put :update_all
      end
    end
    
    member do
      get :merge_list
      put :merge
    end
  end
  
  resources :teams
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
