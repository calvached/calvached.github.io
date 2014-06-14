---
layout: post
title: "So, you want to be a Mastermind?"
date: 2014-05-30 11:10:29 -0500
comments: true
categories: [tech]
---
![Mastermind](http://i.imgur.com/ANjI6Vi.png)

For the last few days I've been writing tests for a game I'm working on called __Mastermind__.
<!-- more -->
The rules are simple. There are two players, the Codemaker (AI) and the Codebreaker (human player). The Codemaker is in charge of creating a four letter pattern from a given set of six letters (A-F). The Codebreaker's job is to correctly guess the pattern in the least number of tries (max of 10 tries). After each attempt the Codemaker gives the Codebreaker feedback by indicating how many letters are correct and in the right position by returning a 'o' for each exact match. Letters that are in the wrong position, but exist in the pattern will return an 'x'.  
For instance if the Codemaker's pattern were "AFDE" and the Codebreaker's guess were "ADFE" then the returned feedback will look like this: "ooxx".

There were two particular pieces of logic that were giving me trouble. The first had to do with the logic behind finding letters that matched the CM's pattern in the correct position. 

``` ruby Find matching letters with the correct position
def letter_with_position_match(user_guess)
	@indexes = []
	counter = []
	user_guess.each_with_index do |cb_letter, cb_i|
			if @unsolved_pattern.include?(cb_letter)
				@unsolved_pattern.each_with_index do |cm_letter, cm_i|
				  if cb_letter == cm_letter && cb_i == cm_i
				  	@indexes << cm_i
				  	counter << cb_letter 
				  end
				end
			end
		end

	counter.length
end
```

I came up with a working algorithm by iterating through the CB's pattern and the CM's pattern, taking each individual letter and index from both, and comparing them. If a letter matched then it's index also had to match. At this point I also decided that I needed to hold on to those indexes so that I would know which letters haven't been matched yet. 

Although this code works, it definitely doesn't look very readable and it's plagued with repetition. After sitting down with my mentor, Kelly, we decided to take this a different route and begin with TDD (test driven development) instead. With TDD you first write a test, then write the code to pass the test, and repeat. With practice, TDD serves as a guideline in writing clean and simple code. 

We started with simple tests like the ones below.

``` ruby codemaker_spec.rb https://github.com/calvached/mastermind/blob/master/spec/codemaker_spec.rb Source Article
describe CodeMaker do

  context "position matches" do
    it "returns 4 if the guess matches pattern exactly" do
      codemaker = CodeMaker.new
      codemaker.unsolved_pattern = ["A", "B", "E", "E"]
      expect(codemaker.feedback(["A", "B", "E", "E"])).to eq(["o", "o", "o", "o"])
    end

    it "returns 0 if the guess has no letters in the same position as the pattern" do
      codemaker = CodeMaker.new
      codemaker.unsolved_pattern = ["A", "B", "C", "D"]
      expect(codemaker.feedback(["F", "F", "F", "F"])).to eq([])
    end

    it "returns 3 if the guess has 3 letters in the same position as the pattern" do
      codemaker = CodeMaker.new
      codemaker.unsolved_pattern = ["A", "B", "C", "D"]
      expect(codemaker.feedback(["A", "B", "C", "F"])).to eq(["o", "o", "o"])
    end
  end
end
```
Each test only tests one small feature. Every new test we wrote became more specific and addressed the next feature that we needed to cover. Eventually our tests looked like [this](https://github.com/calvached/mastermind/blob/master/spec/codemaker_spec.rb).

As a result we were able to improve my icky icky method from before into something more decent and readable.

``` ruby codemaker.rb https://github.com/calvached/mastermind/blob/master/lib/codemaker.rb Source Article
def exact_feedback
		@matches_indexes = []
		results = []

		@guess.each_with_index do |letter, i|
			if @unsolved_pattern[i] == letter
				results << 'o' 
				@matches_indexes << i
			end
		end

		results
	end
```

The second bump in the road I ran into was in iterating through the CB's guess and checking whether they guessed any letters correctly even if in the wrong position. The problem here was that I didn't want to iterate through letters that were already matched in my first method (which is why I saved the indexes from the first matches).

``` ruby codemaker.rb https://github.com/calvached/mastermind/blob/master/lib/codemaker.rb Source Article
def get_unmatched(sequence, matched_placeholder)
  	new_sequence = sequence.clone

  	@matches_indexes.each do |position|
  		new_sequence[position] = matched_placeholder
  	end

  	new_sequence
  end
```

To find the unmatched letters I first had to clone (or duplicate) the pattern so that my original pattern will stay intact. Using the new cloned pattern I replaced all the letters at every index location with a symbol then returned the new cloned pattern. 

``` ruby codemaker.rb https://github.com/calvached/mastermind/blob/master/lib/codemaker.rb Source Article
def letter_feedback
  	results = []

  	get_unmatched(@guess, '+').uniq.each do |letter|
  	  results << 'x' if get_unmatched(@unsolved_pattern, '-').include?(letter)
  	end

		results
end
```

Skipping the already matched letters was only part of the problem, the second part involved duplicate letters in the CM's and the CB's patterns. I created an algorithm where I thought I solved the problem by using the .uniq method, but what I didn't take into account was that the CB's pattern also had to be modified for letters that were already matched.  
For instance if the CM's pattern was "EDEC" and the CB guessed "EDDD". I would expect for the feedback to look something like this "oo", but instead I was getting "oox". By using the get_unmatched method on not only the CM's pattern, but also the CB's pattern I was able to fix the error I was getting.

Mastermind has actually been really fun to build, tear down, build again and refactor! Implementing tests has made it so much easier to work on error cases.
