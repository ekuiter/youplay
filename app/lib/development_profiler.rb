class DevelopmentProfiler
  def self.prof(file_name)
    RubyProf.start
    yield
    results = RubyProf.stop
    File.open "#{Rails.root}/tmp/#{file_name}-graph.html", 'w' do |file|
      RubyProf::GraphHtmlPrinter.new(results).print(file)
    end
    File.open "#{Rails.root}/tmp/#{file_name}-flat.txt", 'w' do |file|
      # RubyProf::FlatPrinter.new(results).print(file)
      RubyProf::FlatPrinterWithLineNumbers.new(results).print(file)
    end
    File.open "#{Rails.root}/tmp/#{file_name}-stack.html", 'w' do |file|
      RubyProf::CallStackPrinter.new(results).print(file)
    end
  end
end
