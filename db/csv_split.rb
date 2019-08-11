require 'fileutils'
require 'csv'

class CsvSplit

  # opt :file_path, "Path to csv file to be split", type: :string, default: nil
  # opt :new_file_name, "Name of the new files. This will be appended with an incremented number", type: :string, default: 'split' #Please note later i change the default name to {original_filename}-{inc#}.csv
  # opt :include_headers, "Include headers in new files", default: true, type: :boolean
  # opt :line_count, "Number of lines per file", default: 1, type: :integer #change default to 1
  # opt :delimiter, "Charcter used for Col. Sep.", default: ',', type: :string #Add custom delimiter


  def self.split(file_path = nil, line_count = 10, new_file_name = 'split',  include_headers = true, delimiter = ',', remove_columns = false)
    #Remind users to provide ARGVs at command-line
    if file_path.nil?
      print "Must provide Path & Filename for processing"
      exit
    end

    #Get path for processing
    path_name = File.dirname(file_path)

    #Stop if remove_columns is enbabled but remove.csv is missing and/or broken
    if remove_columns == true
      #Stop if remove.csv missing or broken
      unless File.exists?("#{path_name}/remove.csv")
        puts "remove.csv is missing or mis-formatted. Please check remove-sample.csv for format"
        exit
      end
    end

    #Disliked Converted file as directory name so changed defual to split_files
    split_path_name = 'split_files'

    #Clean-up previous processing of file by deleting previously processes split-file directory
    if File.exists?(Rails.root.to_s + "/db/#{split_path_name}")
      FileUtils.rm_r "#{path_name}/#{split_path_name}"
      FileUtils::mkdir_p "#{path_name}/#{split_path_name}"
    else
      FileUtils::mkdir_p "#{path_name}/#{split_path_name}"
    end


    #Change default of split files to the original file name unless recieves input
    if new_file_name == "split"
      s = file_path
      s_name = s.split('/')[-1] #Get name of original CSV without path
      split_name = s_name.split('.')[0]
    else
      s = new_file_name
      s_name = s.split('/')[-1] #Sanitizing incase user adds a path but overkill
      split_name = s_name.split('.')[0]
    end



    file = File.expand_path(file_path)
    col_data = []
    index = 1
    file_int = 0
    new_file_tmp = Rails.root.to_s + "/db/#{split_path_name}/#{split_name}-%d.csv"
    new_file = sprintf new_file_tmp, file_int
    headers = [];

    CSV.foreach(file, {headers: true, encoding: "UTF-8", quote_char: '"', col_sep: delimiter}) do |row|

      if include_headers && headers.empty?
        headers = row.to_hash.keys
      end
      col_data << row
      if index % line_count == 0
        CSV.open(new_file, "wb", force_quotes: true) do |csv|

          if include_headers
            csv << headers
          end

          col_data.each do |d|
            csv << d
          end


        end
        file_int = file_int + 1
        new_file = sprintf new_file_tmp, file_int
        col_data = []

      end
      index = index + 1
    end

    #Added se the ability to process the split files (leaving original split files) and removing columns

    if remove_columns == true

      #Clean-up previous processing and create new directory for the split files with columns removed
      split_path_name_rmv_cols = "split_files_rmv_cols"
      if File.exists?(split_path_name_rmv_cols)
        FileUtils.rm_r "#{path_name}/#{split_path_name_rmv_cols}"
        FileUtils.mkdir_p "#{path_name}/#{split_path_name_rmv_cols}"
      else
        FileUtils.mkdir_p "#{path_name}/#{split_path_name_rmv_cols}"
      end

      Dir.glob("#{path_name}/#{split_path_name}/*.csv") do |csv_name|

        original = CSV.read(csv_name, { headers: true, return_headers: true, encoding: "UTF-8", quote_char: '"', col_sep: delimiter })

        rmv_col_names =[]
        rmvr = 0

        list = CSV.foreach('remove.csv', {headers: true, encoding: "UTF-8", quote_char: '"', col_sep:","}) do |row|
          rmv_col_names << row[0]
        end

        rmv_col_count = rmv_col_names.count

        while rmvr < (rmv_col_count-1)
          original.delete("#{rmv_col_names[rmvr]}")
          rmvr +=1
        end

        csv_rmv_name = csv_name.split('/')[-1]

        CSV.open("#{path_name}/#{split_path_name_rmv_cols}/#{csv_rmv_name}", 'w') do |csv|
          original.each do |row|
            csv << row
          end
        end
      end
    end
  end

  # Flush and recreate directory after use
  def self.flush_dir dir
    if File.exists?(dir)
      FileUtils.rm_r dir
      FileUtils::mkdir_p dir
    end

  end
end
