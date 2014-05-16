require 'fileutils'

module XMLFindReplace
  def self.run
    destination_folder = 'Navteq_new'
    create_folder destination_folder

    Dir.glob('Navteq_copy/*.xml').each do |xml_file|
      content = file_to_string xml_file
      new_xml_file_name = self.get_new_xml_file_name xml_file
      content = find_and_replace( content, new_xml_file_name )
      write_file( destination_folder, new_xml_file_name, content )
    end
  end

  def self.create_folder folder_name
    FileUtils.mkdir_p( folder_name ) unless File.directory? folder_name
  end

  def self.find_and_replace content, xml_file
    puts "find and replace -- #{xml_file} --"

    content.gsub!(/<poi>(\s+)<id>(\d*)<\/id>(\s+)<name>(.*)<\/name>/i) do
      "<poi>#{$1}<id>#{$2}<\/id>#{$3}<language-code>en</language-code>#{$3}<name>#{$4}<\/name>"
    end

    content.gsub!(/<type>Entertainment<\/type>/) do
      "<type>Night</type>"
    end

    content
  end

  def self.get_new_xml_file_name(file)
    file.sub(/^.*\/(.*)$/i) { $1 }
  end

  def self.file_to_string file
    content = ''
    IO.foreach(file) do |line|
      content += line
    end
    content
  end

  def self.write_file(folder_name, file_name, content)
    File.open( "#{folder_name}/#{file_name}", 'w' ) { |file| file.puts content }
  end
end
