class CreateG5AuthenticatableRoles < ActiveRecord::Migration
  def change
    create_table(:g5_authenticatable_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:g5_authenticatable_users_roles, :id => false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:g5_authenticatable_roles, :name)
    add_index(:g5_authenticatable_roles, [ :name, :resource_type, :resource_id ],
              name: 'index_g5_authenticatable_roles_on_name_and_resource')
    add_index(:g5_authenticatable_users_roles, [ :user_id, :role_id ])
  end
end
