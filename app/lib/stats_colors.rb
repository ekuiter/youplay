module StatsColors
  @i = -1

  def self.reset
    @i = -1
  end

  def self.color(transparency = 1)
    return colors(transparency)[0] if @i == -1
    colors(transparency)[@i]
  end

  def self.next_color(transparency = 1)
    @i < colors.length - 1 ? @i += 1 : @i = 0
    color(transparency)
  end

  def self.generate_color
    "#%06x" % (rand * 0xffffff)
  end
  
  private

  def self.colors(transparency = 1)
    colors = ["115,115,115", "241,90,96", "122,195,106", "90,155,212", "250,167,91", "158,103,171", "206,112,88", "215,127,180" ]
    colors.map do |color|
      "rgba(#{color},#{transparency})"
    end
  end
end
