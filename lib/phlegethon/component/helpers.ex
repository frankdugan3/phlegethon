defmodule Phlegethon.Component.Helpers do
  @moduledoc """
  A library of helpers for using/authoring Phlegethon components.
  """

  require Logger

  @gettext_backend Application.compile_env!(:phlegethon, :gettext)

  @doc """
  Gets the `values` option for a given component and prop.

  ## Examples

      iex> get_prop_value_opts(Core, :button, :overridables, :color)
      ["root", "primary", "red", "yellow", "green"]
  """
  @spec get_prop_value_opts(module(), atom(), :attrs | :overridables | :slots, atom()) :: any()
  def get_prop_value_opts(module, component, kind, name) do
    opts =
      get_by_path(
        module.__components__,
        [component, kind, &(&1.name == name), :opts, :values],
        :not_found
      )

    if opts == :not_found do
      Logger.error("Values option not found for #{module}.#{component} :#{kind} :#{name}")
      []
    else
      opts
    end
  end

  @doc """
  Extract a value from nested structures (e.g. assigns) for a given key or path of keys with an optional fallback value (defaults to `nil`).

  ## Examples

      iex> get_by_path(assigns(), :class)
      "bg-red-500"

      iex> get_by_path(assigns(), [:user, :name])
      "John Doe"

      iex> get_by_path(assigns(), [:picks, :libs])
      "Ash"

      iex> get_by_path(assigns(), [:user, :non_existing_field], "N/A")
      "N/A"

      iex> get_by_path(assigns(), nil, "N/A")
      "N/A"

      iex> get_by_path(nil, :name, "N/A")
      "N/A"

      iex> get_by_path(Core.__components__, [:button, :overridables, &(&1.name == :color), :opts, :values])
      ["root", "primary", "red", "yellow", "green"]
  """
  @spec get_by_path(any(), atom() | list(atom()), any()) :: any()
  def get_by_path(value, keys, default \\ nil)

  def get_by_path(_value, nil, default), do: default

  def get_by_path(value, key, default) when not is_list(key),
    do: get_by_path(value, List.wrap(key), default)

  def get_by_path(nil, _, default), do: default
  def get_by_path(_, [nil], default), do: default

  def get_by_path(%{} = value, [key | rest], default),
    do: get_by_path(Map.get(value, key, default), rest, default)

  def get_by_path(value, [finder | rest], default) when is_list(value) and is_function(finder, 1),
    do: get_by_path(Enum.find(value, finder), rest, default)

  def get_by_path(value, [key | rest], default) when is_list(value),
    do: get_by_path(Keyword.get(value, key, default), rest, default)

  def get_by_path(value, [], _default), do: value

  @doc false
  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(@gettext_backend, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(@gettext_backend, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end