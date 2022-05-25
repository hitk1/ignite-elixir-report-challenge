defmodule GenReport.Parser do
  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  def parse_file(filepath) do
    filepath
    |> File.stream!()
    |> Stream.map(&format_line(&1))
  end

  def gen_month_list, do: @months

  def gen_year_list, do: [2016, 2017, 2018, 2019, 2020]

  defp format_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> map_through_month()
    |> List.update_at(4, &String.to_integer/1)
  end

  defp map_through_month(line) do
    List.update_at(line, 3, &get_month_name/1)
  end

  defp get_month_name(month_number) when is_binary(month_number),
    do: get_month_name(String.to_integer(month_number))

  defp get_month_name(month_name), do: Enum.at(@months, month_name - 1)
end
