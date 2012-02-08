#Program to find friends of a word (using Levenshtein distance)

require 'thread'

#Read the file of words
def readfile(filename)
    _allwords = Array.new
	file = File.new(filename.to_s, "r")
	while(line = file.gets)
		_allwords << line.squeeze
	end
	file.close
    return _allwords
end

#remove entries from array which have length other than lengthofword, since the friends of a word can be only equal to the length of the word
def removeentries(allwords, lengthofword)
    _newarray = Array.new
    for i in 0...allwords.length
	word = allwords[i]
	wlen = word.length - 1 
        if wlen == lengthofword
	    _newarray << allwords[i]
        end
    end
    return _newarray
end

#to determine if a word is a friend of another word
def isfriend(word1, word2)
    if !word1.nil? || !word2.nil?
    	count = 1
    	for i in 0...word1.length
        	if word1[i] == word2[i]
        	    count = count+1
        	end
    	end
    	if count == word1.length
       		return true
    	else
        	return false
    	end
    end
    return false
end

#to check if word is not already in the friends list
def uniqueword(word, friends)
    for i in 0...friends.length
        if word == friends[i]
            return false
        end
    end
    return true
end

#to check if word is not already in the queue
def uniqueinqueue(word, queue)
	queue_dup = Queue.new
	decision = true
	while queue.empty?
	word1 = queue.pop
		if word == word1		#duplicate found
			decision = false
		end
		queue_dup << word1
	end
	return decision
end

#to find friends of a word
def findfriends(inputword, allwords, queue, friends)
    for i in 0...allwords.length
        if isfriend(inputword, allwords[i])
            if uniqueword(allwords[i], friends)
                if uniqueinqueue(allwords[i], queue)
			queue << friends[i]
		end
            end
        end
    end
    return queue, friends
end        

inputword = ARGV[0].to_s
filename = ARGV[1].to_s
allwords = readfile(filename)
lengthofword = inputword.length
allwords = removeentries(allwords,lengthofword)

friends = Array.new
queue = Queue.new
for i in 0...allwords.length
    if isfriend(inputword, allwords[i])
        queue << allwords[i]
    end
end

friends << inputword+"\n"

while(queue.length != 0)
    pop_word_from_queue = queue.pop
    if !pop_word_from_queue.nil?
    	queue, friends = findfriends(pop_word_from_queue, allwords, queue, friends)
    	friends << pop_word_from_queue
    end
end
friends.uniq!
for i in 0...friends.length
	print(friends[i])
end

print("The total social network of the word is: " + friends.length.to_s + "\n")
