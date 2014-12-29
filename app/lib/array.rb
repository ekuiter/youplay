class Array
  def generate_colors!
    map! do |elem|
      elem = {}.merge(elem)
      elem[:color] = StatsColors.next_color
      elem
    end
  end
end
