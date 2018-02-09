
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# <firstname> <lastname>
# <email-address>
#
###############################################################

$bigrams = Hash.new{|hash,key| hash[key] = Hash.new{|hash,key| hash[key] = 0}} # The Bigram data structure
$name = "<Madison> <Fichtner>"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "
	begin
		IO.foreach(file_name, encoding: "utf-8") do |line|													#for each line
			title = cleanup_title(line)																								#clean up title
			if title != nil																														#unless the title doesnt exist
				words = title.split(/\s/)																								#split the title into seperate words and remove all the stop words mentioned in the lab
				words.delete("a")
				words.delete("an")
				words.delete("and")
				words.delete("by")
				words.delete("for")
				words.delete("from")
				words.delete("in")
				words.delete("of")
				words.delete("on")
				words.delete("or")
				words.delete("out")
				words.delete("the")
				words.delete("to")
				words.delete("with")
				(0..words.size-2).each do |i|																						# for the size of the words array minus two because we dont want to check bigrams of the last word
					if $bigrams["#{words[i]}"]["#{words[i+1]}"].nil?										#if the first layer doesnt contain the current word, add it with it's following word with a value of 1
						$bigrams["#{words[i]}"].store("#{words[i+1]}", 1)
					else																																	#otherwise, increment the value of the following key word
						$bigrams["#{words[i]}"]["#{words[i+1]}"] += 1
					end
				end
			end
			#p $bigrams.values.inspect
		end
		#puts mcw("a")
		puts "Finished. Bigram model built.\n"
	#rescue
		#STDERR.puts "Could not open file"
		#exit 4
	end
end

def mcw(word)																																		#most common word function
	if !$bigrams.has_key?(word)																										#check to see if bigrams contains word, if it doesnt return nil
		return nil
	elsif $bigrams.has_key?(word)																									#if bigrams has word, call largest_key given the word
		return largest_key(word)
	end
end

def largest_key(word)																														#largest key function
	max = 0																																				#Initialize max and mostFound to 0 and "". max is the highest occurence value for bigrams, and mostFound is the second word in the bigram
	mostFound = ""
	$bigrams["#{word}"].each {|key, block|																				#for each following key for the given word, compare if the key's occurences is greater
		if block == max  	 																													#if the current bigram keys value is equal to the current greatest, randomize which one is the new most occuring
			random = 0 + Random.rand(2)
			if random == 0
				max = block
				mostFound = key
			end
		end
		if block > max																												#if the occurence is greater than max set the max to the current keys value and set mostfound to this key
			max = block
			mostFound = key
		end
		#maxNum = $bigrams["#{word}"][mostFound]
	}
	return mostFound																															#return greatest occuring key of word
end

def cleanup_title(line)
	if line =~ /(\w+)\<SEP>(\w+)\<SEP>(.*)<SEP>(.*$)/ #regex to break up line			# do something for each line
		title = $4
		#regex to remove ending special characters
		title.gsub!(/\s*(\(|\[|\{|\\|\/|_|-|:|"|`|\+|=|\*|feat\.).*$/, "")					#removing end characters
		title.gsub!(/[\?|¿|\!|¡|\.|;|\&|@|%|\#|\|]/, '')													#removing special characters
		if title =~ /(^\w^\s')/																										#if title has non-english characters
			return nil
		end
		title = title.downcase																										#making title lowercase
	#p title
	end
	return title
end

def create_title(word)
	first_word = word																															#create a variable to store the initial word entered
	title = word																																	#append this word to the final title
	length = 1																																		#initialize length to 1 for creating titles of length 20
	while length < 20 # true				#while length < 20																					#while loop, will continue running until it breaks due to duplicated word or if theres no next word found
		word = mcw(word)
		if word.eql?(nil) && length == 1																						#if the mcw generated does not exist, and the length of the title is 1, return the first_word entered (initial word entered)
			return first_word
		elsif word.eql?(nil)
			break;
		end
		break if title.include? word																								#break if the title includes the next mcw
		title = title + " " + word																									#append the next mcw to the title
		length = length + 1																													#increment length
	end
	puts title
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
	while true																																		#continue looping until user input is 'q'
		print("Enter a word [Enter 'q' to quit]: ")
		input = $stdin.gets.chomp																										#receive user input
		if input.eql?('q')
			break
		end
		create_title(input)
	end
end

if __FILE__==$0
	main_loop()
end
