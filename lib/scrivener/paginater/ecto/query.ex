defimpl Scrivener.Paginater, for: Ecto.Query do
  import Ecto.Query

  alias Scrivener.{Config, Page}

  @moduledoc false

  @spec paginate(Ecto.Query.t(), Scrivener.Config.t()) :: Scrivener.Page.t()
  def paginate(query, %Config{
        page_size: page_size,
        page_number: page_number,
        module: repo,
        caller: caller,
        options: options
      }) do
    total_count =
      Keyword.get_lazy(options, :total_count, fn -> total_count(query, repo, caller) end)

    total_pages = total_pages(total_count, page_size)
    page_number = min(total_pages, page_number)

    %Page{
      page_size: page_size,
      page_number: page_number,
      entries: entries(query, repo, page_number, page_size, caller),
      total_count: total_count,
      total_pages: total_pages
    }
  end

  defp entries(query, repo, page_number, page_size, caller) do
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> repo.all(caller: caller)
  end

  defp total_count(query, repo, caller) do
    total_count =
      query
      |> exclude(:preload)
      |> exclude(:order_by)
      |> prepare_select
      |> count
      |> repo.one(caller: caller)

    total_count || 0
  end

  defp prepare_select(
         %{
           group_bys: [
             %Ecto.Query.QueryExpr{
               expr: [
                 {{:., [], [{:&, [], [source_index]}, field]}, [], []} | _
               ]
             }
             | _
           ]
         } = query
       ) do
    query
    |> exclude(:select)
    |> select([x: source_index], struct(x, ^[field]))
  end

  defp prepare_select(query) do
    query
    |> exclude(:select)
  end

  defp count(query) do
    query
    |> subquery
    |> select(count("*"))
  end

  defp total_pages(0, _), do: 1

  defp total_pages(total_count, page_size) do
    (total_count / page_size) |> Float.ceil() |> round
  end
end
