#!/usr/bin/ruby

require 'set'

# Note:
# 
# Responsibility of this script:
# 1. Read result from CodeSurfer scheme program that detect clones
# 2. Clean subsumed clones and grouping clones
# 3. Display statistic of the clones found
# 
# An example of how input and output looks like can be found at the bottom of this file


# read raw input        
SEPARATOR = "===>"
rawResult = File.new(ARGV[0], "r")
totalClones = Hash.new

while(line = rawResult.gets)
	file1, method1, data1, file2, method2, data2, tag = line.split(SEPARATOR)

	if(file1 != nil and method1 != nil and data1 != nil and file2 != nil and method2 != nil and data2 != nil) 
		key = file1 + ":" + method1 + "() " + SEPARATOR + " " + file2 + ":" + method2 + "()"
		currentClones = totalClones[key]
		
		if(currentClones == nil) 
			totalClones[key] = [ [data1, data2] ]
		else
			# make sure to remove subsumed clones
			if(!currentClones.include?([data1, data2]))
				currentClones.push( [data1, data2] )
			end
		end
	end
end

filteredTotalClones = Hash.new
cloneFragmentSizes = Array.new
totalCloneFragmentSize = 0

# filtering clone with minimum 5 nodes and collecting statistics
totalClones.each do |key, clones|
	uniqueLines = Set.new
	
	clones.each do |value|
		firstLineData = value[0].split(":")
		uniqueLines.add(firstLineData[0])
	end

	if(uniqueLines.size >= 5)
		filteredTotalClones[key] = clones.sort
		cloneFragmentSizes.push(uniqueLines.size)
		totalCloneFragmentSize += uniqueLines.size
	end
end

cloneRange5To9 = cloneFragmentSizes.select{|size| size >= 5 and size <= 9}.size
cloneRange10To19 = cloneFragmentSizes.select{|size| size >= 10 and size <= 19}.size
cloneRange20To29 = cloneFragmentSizes.select{|size| size >= 20 and size <= 29}.size
cloneRange30To39 = cloneFragmentSizes.select{|size| size >= 30 and size <= 39}.size
cloneRange40To49 = cloneFragmentSizes.select{|size| size >= 40 and size <= 49}.size
cloneRange50To59 = cloneFragmentSizes.select{|size| size >= 50 and size <= 59}.size
cloneRange60To69 = cloneFragmentSizes.select{|size| size >= 60 and size <= 69}.size
cloneRange70AndMore = cloneFragmentSizes.select{|size| size >= 70}.size

puts "\n======================================================"
puts " Total number of nodes for all clones:             " + totalCloneFragmentSize.to_s
puts ""
puts " # Clone groups with range 5 to 9 nodes:           " + cloneRange5To9.to_s
puts " # Clone groups with range 10 to 19 nodes:         " + cloneRange10To19.to_s
puts " # Clone groups with range 20 to 29 nodes:         " + cloneRange20To29.to_s
puts " # Clone groups with range 30 to 39 nodes:         " + cloneRange30To39.to_s
puts " # Clone groups with range 40 to 49 nodes:         " + cloneRange40To49.to_s
puts " # Clone groups with range 50 to 59 nodes:         " + cloneRange50To59.to_s
puts " # Clone groups with range 60 to 69 nodes:         " + cloneRange60To69.to_s
puts " # Clone groups with range more than 70 nodes:     " + cloneRange70AndMore.to_s
puts "======================================================\n"

puts "\n"
counter = 1
filteredTotalClones.each do |key, clones|
	puts "===================="
	puts " Clone Fragments " + counter.to_s
	puts "===================="
	puts "* " + key
	clones.each do |value|		
		puts value[0] + " " + SEPARATOR + " " + value[1]
	end
	counter += 1
	puts ""
end


# ==========================================================
#  EXAMPLE OF INPUT AFTER RUNNING CODESURFER SCHEME PROGRAM
# ==========================================================
# 
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 8: j = i * i + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 26: b = a * a + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 17: k = i + j - 1===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 35: c = a + b - 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 8: j = i * i + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 26: b = a * a + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: count++
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 6: j = i + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: for ( count<10===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: for ( s<10
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 8: j = i * i + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 26: b = a * a + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: s++
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: for ( count<10===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: for ( s<10
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 14: j = j + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 24: b = a + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: count++===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 6: j = i + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: count++===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: for ( count<10===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: for ( s<10
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: count++===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: s++
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: for ( count<10===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: for ( s<10
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 12: count++===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 24: b = a + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 6: j = i + 1===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 6: j = i + 1===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: s++
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 6: j = i + 1===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 24: b = a + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>foo===>Line 7: j = i * 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 25: b = a * 5
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: s++
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 32: b = b + 5===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 24: b = a + 1
# /Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 30: s++===>/Users/amhamid/dev/sandbox/csurf-foo/lib.c===>bar===>Line 24: b = a + 1


# ========================
#  EXAMPLE OF END RESULT
# ========================
# 
# ~/dev/master-thesis/src (master)$ ./GroupingClones.rb /Users/amhamid/dev/sandbox/csurf-foo/Foo-raw-result.txt

# ======================================================
#  Total number of nodes for all clones:             6

#  # Clone groups with range 5 to 9 nodes:           1
#  # Clone groups with range 10 to 19 nodes:         0
#  # Clone groups with range 20 to 29 nodes:         0
#  # Clone groups with range 30 to 39 nodes:         0
#  # Clone groups with range 40 to 49 nodes:         0
#  # Clone groups with range 50 to 59 nodes:         0
#  # Clone groups with range 60 to 69 nodes:         0
#  # Clone groups with range more than 70 nodes:     0
# ======================================================

# ====================
#  Clone Fragments 1
# ====================
# * /Users/amhamid/dev/sandbox/csurf-foo/lib.c:foo() ===> /Users/amhamid/dev/sandbox/csurf-foo/lib.c:bar()
# Line 8: j = i * i + 5 ===> Line 26: b = a * a + 5
# Line 17: k = i + j - 1 ===> Line 35: c = a + b - 1
# Line 14: j = j + 5 ===> Line 32: b = b + 5
# Line 12: for ( count<10 ===> Line 30: for ( s<10
# Line 14: j = j + 5 ===> Line 30: s++
# Line 14: j = j + 5 ===> Line 24: b = a + 1
# Line 12: count++ ===> Line 32: b = b + 5
# Line 12: count++ ===> Line 30: s++
# Line 12: count++ ===> Line 24: b = a + 1
# Line 6: j = i + 1 ===> Line 32: b = b + 5
# Line 6: j = i + 1 ===> Line 30: s++
# Line 6: j = i + 1 ===> Line 24: b = a + 1
# Line 7: j = i * 5 ===> Line 25: b = a * 5
