module Unzipper

  module ZIP
    def self.decompress file, destination = nil
      require 'zip/zip'
      Zip::ZipFile.open(file) do |zipped_files|
        zipped_files.each do |zipped_file|
          file_path = destination ? File.join(destination, zipped_file.name) : zipped_file.name
          FileUtils.mkdir_p(File.dirname(file_path)) if destination
          zipped_files.extract(zipped_file, file_path) unless File.exist?(file_path)
        end
      end
    end
  end

  module BZ2
    def self.decompress filename
      require 'bzip2-ruby'
      string = nil
      Bzip2::Reader.open(filename) do |compressed_file|
        string = compressed_file.read
      end
      return string
    end
  end

end