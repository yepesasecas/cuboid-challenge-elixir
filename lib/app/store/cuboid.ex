defmodule App.Store.Cuboid do
  @moduledoc """
  This module defines the Cuboid schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "cuboids" do
    field :depth, :integer
    field :height, :integer
    field :width, :integer
    field :volume, :integer
    belongs_to :bag, App.Store.Bag

    timestamps()
  end

  @doc false
  def changeset(cuboid, attrs) do
    cuboid
    |> cast(attrs, [:width, :height, :depth, :bag_id])
    |> validate_required([:width, :height, :depth])
    |> cast_assoc(:bag, require: true)
    |> assoc_constraint(:bag, require: true)
    |> validate_volume_space()
  end


  defp validate_volume_space(%{valid?: false} = changeset), do: changeset
  defp validate_volume_space(%{valid?: true, changes: changes} = changeset) do
    %{width: width, height: height, depth: depth, bag_id: bag_id} = changes
    bag = App.Store.get_bag(bag_id)
    if bag do
      cuboidVolume = height * depth * width
      if cuboidVolume <= bag.availableVolume do
        changeset
      else
        add_error(changeset, :volume, "Insufficient space in bag")
      end
    end
  end

  def update_changeset(cuboid, attrs) do
    cuboid
    |> cast(attrs, [:width, :height, :depth, :bag_id])
    |> validate_required([:width, :height, :depth])
    |> cast_assoc(:bag, require: true)
    |> assoc_constraint(:bag, require: true)
    |> validate_update_volume_space()
  end


  defp validate_update_volume_space(%{valid?: false} = changeset), do: changeset
  defp validate_update_volume_space(%{valid?: true, changes: changes, data: %App.Store.Cuboid{bag_id: bag_id}} = changeset) do
    %{width: width, height: height, depth: depth} = changes
    bag = App.Store.get_bag(bag_id)
    if bag do
      cuboidVolume = height * depth * width
      if cuboidVolume <= bag.availableVolume do
        changeset
      else
        add_error(changeset, :volume, "Insufficient space in bag")
      end
    end
  end
end
