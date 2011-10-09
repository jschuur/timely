module ApplicationHelper
  def hourly_select_options
    (0..23).map do |hour|
      if hour == 0
        ["12:00AM", hour]
      elsif hour < 12
        ["#{hour}:00AM", hour]
      elsif hour == 12
        ["12:00PM", hour]
      else
        ["#{hour-12}:00PM", hour]
      end
    end
  end
end
