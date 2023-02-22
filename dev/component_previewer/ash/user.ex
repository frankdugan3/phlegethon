defmodule ComponentPreviewer.Ash.Ash.User do
  @moduledoc false
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    extensions: [Phlegethon.Resource],
    notifiers: [Ash.Notifier.PubSub]

  phlegethon do
    resource_label "User"
    default_display_mode :card_grid

    form do
      action_type [:create, :update] do
        class "max-w-md justify-self-center"

        field_group :primary do
          label "Primary Info"
          class "md:grid-cols-2"

          field :name do
            description "Your full real name"
            autofocus true
          end

          field :email
        end

        field :notes do
          type :long_text
          input_class "min-h-[10rem]"
        end
      end

      action [:create, :update]
    end
  end

  pub_sub do
    prefix "user"
    module ComponentPreviewer.Endpoint

    publish_all :create, "created"
    publish_all :update, ["updated", [:id, nil]]
    publish_all :destroy, ["destroyed", [:id, nil]]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, allow_nil?: false

    attribute :email, :string,
      sensitive?: true,
      allow_nil?: false,
      constraints: [
        max_length: 160,
        match: ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[A-Z0-9-]+(\.[A-Z0-9-]+)*$/i
      ]

    attribute :notes, :string, description: "Note anything unusual about yourself"
  end

  relationships do
    belongs_to :best_friend, __MODULE__
  end

  actions do
    defaults [:read, :update, :destroy]

    read :list do
      prepare build(sort: [:name])
    end

    create :create do
      primary? true
      description "Just an ordinary create action."
    end
  end

  code_interface do
    define_for ComponentPreviewer.Ash.Ash.Api

    define :list, action: :list
    define :by_id, action: :read, get_by: [:id]
    define :create, action: :create
    define :destroy, action: :destroy
  end
end