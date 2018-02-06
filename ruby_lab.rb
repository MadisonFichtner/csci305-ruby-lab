
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "<Madison> <Fichtner>"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
# (\w+)\<SEP>(\w+)\<SEP>(.*)<SEP>(.*)
	begin
		IO.foreach(file_name, encoding: "utf-8") do |line|
			title = cleanup_title(line)
			if title != nil
				words = title.split
				i = 0
				words.each do |word|
					p words[i]
					if !$bigrams.has_key?(word)
						$valueHash = Hash.new
						$bigrams.store(word, $valueHash)	#create new hash for interior)	#initialize value of first occurence of word
						#p words[i+1]
					else	#if bigrams has word, check next word to add
						#p $bigrams.fetch(words)
						if $valueHash.has_key?(words[i+1])
							value = $valueHash.fetch(words[i+1])
							$valueHash.store(word[i+1], value)
						elsif !$valueHash.has_key?(words[i+1])
							$valueHash.store(words[i+1], 1)
						end
					end
					i+=1
				end
			end
			#p $bigrams.keys.inspect
			#p $bigrams.inspect
			#p $valueHash.values.inspect
			#p $valueHash.keys.inspect
		end
		puts mcw("a")
		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

def mcw(word)
	if !$bigrams.has_key?(word)
		return nil
	elsif $bigrams.has_key?(word)
		return largest_key($valueHash)
	end
end

def largest_key(hash)
	hash.key(hash.values.max)
	#hash.max_by{|k,v| v}
end

def cleanup_title(line)
	# do something for each line
	if line =~ /(\w+)\<SEP>(\w+)\<SEP>(.*)<SEP>(.*$)/ #regex to break up line
		title = $4
		#regex to remove ending special characters
		title.gsub!(/(?=\(|\[|\{|\\|\/|\_|\-|\:|\"|\'|\+|\=|\*|feat.).+/, '')	#removing end characters
		title.gsub!(/[?|¿|!|¡|.|;|&|@|%|#||]/, '')	#removing special characters
		title = title.downcase	#making title lowercase
		if title =~ /\W(?<=(\S))/		#if title has non-english characters
			return nil
		end
	end
	return title
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
end

if __FILE__==$0
	main_loop()
end
