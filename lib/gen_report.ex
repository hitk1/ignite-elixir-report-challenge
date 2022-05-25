defmodule GenReport do
  alias GenReport.Parser

  @names [
    "cleiton",
    "daniele",
    "danilo",
    "diego",
    "giuliano",
    "jakeliny",
    "joseph",
    "mayk",
    "rafael",
    "vinicius"
  ]

  def build, do: {:error, "Insira o nome de um arquivo"}

  def build(filename) do
    "csv/#{filename}"
    |> Parser.parse_file()
    |> Enum.reduce(create_acumulator(), &gen_report/2)
  end

  defp gen_report(
         [name, hour, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hour)
    hours_per_month = update_deps(hours_per_month, name, month, hour)
    hours_per_year = update_deps(hours_per_year, name, year, hour)

    make_report_structure(
      all_hours,
      hours_per_month,
      hours_per_year
    )
  end

  defp update_deps(data, key, nested_key, value) do
    formated_object = Map.put(data[key], nested_key, data[key][nested_key] + value)
    Map.put(data, key, formated_object)
  end

  defp make_report_structure(all_hours, hours_per_month, hours_per_year) do
    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp create_acumulator do
    all_names = Enum.into(@names, %{}, &{&1, 0})
    all_months = Enum.into(Parser.gen_month_list(), %{}, &{&1, 0})
    hours_per_month = Enum.into(@names, %{}, &{&1, all_months})

    all_years = Enum.into(Parser.gen_year_list(), %{}, &{&1, 0})
    hours_per_year = Enum.into(@names, %{}, &{&1, all_years})

    make_report_structure(
      all_names,
      hours_per_month,
      hours_per_year
    )
  end
end
