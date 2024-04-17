# Submission information for the Snort HW
# https://aaronbloomfield.github.io/nws/hws/snort/

# The filename of this file must be 'snort.py', else the submission verification
# routines will not work properly.

# You are welcome to have additional variables or fields in this file; you
# just can't remove variables or fields.


# Who are you?  Name and UVA userid.  The name can be in any human-readable
# format.
userid = "mst3k"
name = "Jane Doe"


# This dictionary contains various information that will vary depending on the
# assignment.
other = {
	
	# Pcap analysis: for the *first* pcap file
	# (snort-uva-attack-1.pcap), describe what you found.  The questions to
	# answer are in the homework in the "Pcap Analysis" section.  This should
	# be prose (a normal paragraph).  It is limited to 250 characters, so
	# please keep it brief!
	'snort-uva-attack-1.pcap_description': None,

	# Pcap analysis: for the *second* pcap file
	# (snort-uva-attack-2.pcap), describe what you found.  The questions to
	# answer are in the homework in the "Pcap Analysis" section.  This should
	# be prose (a normal paragraph).  It is limited to 250 characters, so
	# please keep it brief!
	'snort-uva-attack-2.pcap_description': None,

	#------------------------------------------------------------

	# Snort rule creation: pick one of the "suspicious" types of network
	# transmission in the `run_malware` program on the *inner* container.  It
	# doesn't matter which one you pick for this first one, although the
	# first description must match the first rule, of course.  You will do
	# the same for the second and third types of "suspicious" types of
	# network transmissions.

	# Describe what the *first* "suspicious" network transmission is.  This
	# is limted to 50 characters.
	'run_malware-analysis-1-description': None,

	# Enter the Snort rule that will detect the *first* "suspicious" network
	# transmission.  This should only be the Snort rule, not any English
	# description, as we are going to put it into a Snort rules file to test
	# it.
	'run_malware-analysis-1-rule': None,

	# Describe what the *second* "suspicious" network transmission is.  This
	# is limted to 50 characters.
	'run_malware-analysis-2-description': None,

	# Enter the Snort rule that will detect the *second* "suspicious" network
	# transmission.  This should only be the Snort rule, not any English
	# description, as we are going to put it into a Snort rules file to test
	# it.
	'run_malware-analysis-2-rule': None,

	# Describe what the *third* "suspicious" network transmission is.  This
	# is limted to 50 characters.
	'run_malware-analysis-3-description': None,

	# Enter the Snort rule that will detect the *third* "suspicious" network
	# transmission.  This should only be the Snort rule, not any English
	# description, as we are going to put it into a Snort rules file to test
	# it.
	'run_malware-analysis-3-rule': None,

	#------------------------------------------------------------

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

}


# These are various sanity checks, and are meant to help you ensure that you
# submitted everything that you are supposed to submit.  Other than
# submitting the necessary files to Gradescope (which checks for those
# files), all other submission requirements are listed herein.  These values 
# need to be changed to True (instead of False).
sanity_checks = {

	# None!

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
