# Submission information for the Wireshark HW
# https://aaronbloomfield.github.io/nws/hws/wireshark/

# The filename of this file must be 'wireshark.py', else the submission
# verification routines will not work properly.

# You are welcome to have additional variables or fields in this file; you
# just can't remove variables or fields.


# Who are you?  Name and UVA userid.  The name can be in any human-readable
# format.
userid = "mst3k"
name = "Jane Doe"


# This dictionary contains various information that will vary depending on the
# assignment.
other = {
	
	# How comfortable do you feel using Wireshark now that this assignment is
	# completed?  This should be an integer, where 1 is same comfort level, 2
	# is somewhat more comfortable, and 3 is much more comfotable.
	'wireshark_comfort_level': None,

	# In 250 characters or less, explain what you've found in the live network
	# traffic in the Docker containers. You will have to summarize it as best
	# you can, as the autograder will check the length. This entire comment
	# is about 250 characters in length.
	'what_you_found_in_docker': None,

	# In 100 characters, what did you include in your capture.pcap?  This
	# comment is 100 characters long.
	'what_is_in_capture_file': None,

	# Any comments about the live capture exercise?  Let us know if things too
	# easy to find, too hard, too annoying, etc.  This value is unlimited in
	# length.  You don't have to enter comments, but you do have to change
	# the value here from None to, say, an empty string if you don't want to
	# leave any comments.
	'comments_on_live_capture': None,

	# How frustrating was this assignment?  This is an integer on a 1-5 scale,
	# where 1 is not frustrating at all, 2 is a little bit frustrating, 3 is
	# somewhat frustrating, 4 is rather frustrating, and 5 is very
	# frustrating.  A typical, well designed, CS elective homework would
	# probably be around a 1 or 2.
	'frustration_level': None,

	# How hard did you find this assignment?  This is an integer on a 1-5
	# scale, where 1 is very easy, 2 is somewhat easy, 3 is neutral
	# (neither easy or hard), 4 is somewhat hard, 5 is very hard.  A tyipcal,
	# well designed, CS elective homework would be a 3.
	'difficulty': None,

	# Questions to answer: the first 10 are from the "Basic Analysis" section,
	# and the last three are from the "Advanced Analysis" section.  If you
	# don't know the answer, or have not gotten to that, you still have to
	# put a value of the correct type in.

	# Question 1: what is the port number on the client 192.168.100.101)
	# opened for this FTP connection?  This should be an integer.
	'question_1': None,

	# Question 2: what is the username that was used to log in?  This should
	# be a string.
	'question_2': None,

	# Question 3: what was that user's password?  This should be a string.
	'question_3': None,

	# Question 4: what is the password that mst3k entered to log in?  This
	# should be a string.
	'question_4': None,

	# Question 5: what is the URL that was requested?  This should be a string.
	'question_5': None,

	# Question 6: what is the username used to log in?  This should be a string.
	'question_6': None,

	# Question 7: what is the password used to log in?  This should be a string.
	'question_7': None,

	# Question 8: how many SSH packets are present after using the `ssh`
	# filter?  This should be an integer.
	'question_8': None,

	# Question 9: what is the "Encrypted Packet" value for the first SSH
	# packet in the capture?  This should be a string.
	'question_9': None,

	# Question 10: what is the background color (not the font color) of
	# packets that are a bad TCP packet?  This should be a string.
	'question_10': None,

	# Question 11: What is the patient's first name?  This should be a string.
	'question_11': None,

	# Question 12: What is the patient's last name?  This should be a string.
	'question_12': None,

	# Question 13: What is the patient's social security number?  This should
	# be an integer.
	'question_13': None,

}


# These are various sanity checks, and are meant to help you ensure that you
# submitted everything that you are supposed to submit.  Other than
# submitting the necessary files to Gradescope (which checks for those
# files), all other submission requirements are listed herein.  These values 
# need to be changed to True (instead of False).
sanity_checks = {

	# For your capture.pcap file, did you remove all the extra packets that
	# are not related to what you are showing?
	'removed_extra_packets_from_pcap': False,

}


# While some of these are optional, you still have to replace those optional
# ones with the empty string (instead of None).
comments = {

	# How long did this assignment take, in hours?  Please format as an
	# integer or float.
	'time_taken': None,

	# Any suggestions for how to improve this assignment?  This part is
	# completely optional.  If none, then you can have the value here be the
	# empty string (but not None).
	'suggestions': None,

	# Any other comments or feedback?  This part is completely optional. If
	# none, then you can have the value here be the empty string (but not
	# None).
	'comments': None,
}
