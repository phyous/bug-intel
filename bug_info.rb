class BugInfo
  def initialize(data)
    @data = data
  end

  def method_missing(m, *args)
    if @data.has_key?(m)
      @data[m]
    else
      ""
    end
  end

end