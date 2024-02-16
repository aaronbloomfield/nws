# Submission information for the Web of Trust HW
# https://aaronbloomfield.github.io/nws/weboftrust/

# The filename of this file must be 'weboftrust.py', else the submission
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

	# How easy and usable is the process of key signing?  This should be an
	# integer on a scale of 1-5, where 1 is very easy to trivial, 2 is
	# somewhat easy, 3 is neutral, 4 is somewhat difficult, and 5 is very
	# difficult.
	'gpg_usability': None,

	# What are your thoughts on the usability of GPG and key signing?  This
	# doesn't have to be a long comment (although it can be).  This should be
	# a string.
	'gpg_usability_thoughts': None,

	# How many people did you trick by signing their key with your adversarial
	# key?  We are looking for as close a number as you can think of -- it
	# doesn't have to be exact.  This should be an integer.
	'number_tricked': None,

	# If you did trick anybody, how did you go about doing it?  This doesn't
	# have to be a long comment (although it can be).  This should be a string.
	'how_tricked': None,

	# How did you avoid being tricked into having yours signed with an
	# adversarial key?  This doesn't have to be a long comment (although it
	# can be).  This should be a string.
	'how_avoid_tricked': None,

	# How frustrating did you find this assignment?  This should be an integer
	# on a scale of 1-5, where 1 is not frustrating at all, 2 is a little bit
	# frustrating, 3 is a reasonable level of frustration (for however you
	# define reasonable), 4 is very frustrating, and 5 is extremely
	# frustrating.
	'weboftrust_frustration_level': None,

	# In part 2, you sent a GPG encrypted email to the course email, and you
	# got a response containing a code specific to you.  Enter that code
	# here, as a string:
	'specific_code': None,

}


# These are various sanity checks, and are meant to help you ensure that you
# submitted everything that you are supposed to submit.  Other than
# submitting the necessary files to Gradescope (which checks for those
# files), all other submission requirements are listed herein.  These values 
# need to be changed to True (instead of False).
sanity_checks = {

	# Did you sign at least 30 keys of your classmates?  Even if you didn't,
	# answer True here -- it's to remind you that this is part of the
	# assignment.
	'signed_30_keys': None,

	# Did you get your key signed by at least 30 of your classmates?  Even if
	# you didn't, answer True here -- it's to remind you that this is part of
	# the assignment.
	'got_key_signed_by_30': None,

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
