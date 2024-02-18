# Submission information for the Docker Configuration HW
# https://aaronbloomfield.github.io/nws/hws/docker/

# The filename of this file must be 'docker.py', else the submission
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
	
	# Is docker, and the course setup, working on your machine?  We are asking
	# about the overall setup, not the GUI, for this part.  This means that
	# it was instailled succesfully and you were able to start the course
	# containers.  You will still get full credit if you answer False here --
	# I will use that to follow up with you to ensure it works eventually.
	# This should be either True or False.
	'docker_installed_on_machine': None,

	# Were you able to launch a GUI program from a docker container?.  You
	# will still get full credit if you answer False here -- I will use that
	# to follow up with you to ensure it works eventually.  This should be
	# either True or False.
	'docker_gui_working': None,

	# Were you able to get the exploit working?  You will still get full
	# credit if you answer False here -- I will use that to follow up with
	# you to ensure it works eventually.  This should be either True or False.
	'got_vsftp_exploit_working': None,

	# On a scale of 1-5, how well do you feel you understand basic Docker
	# commands?  1 is not at all, 2 a bit, but not much, 3 is neutral, 4 is
	# well, 5 is quite well.
	'docker_command_understanding': None,

	# How frustrating did you find this process?  This is on a scale of 1-5,
	# where 1 is not frustrating at all, 2 is a little bit frustrating, 3 is
	# a reasonable level of frustration (for however you define reasonable),
	# 4 is very frustrating, and 5 is extremely frustrating.
	'docker_frustration_level': None,

}


# These are various sanity checks, and are meant to help you ensure that you
# submitted everything that you are supposed to submit.  Other than
# submitting the necessary files to Gradescope (which checks for those
# files), all other submission requirements are listed herein.  These values 
# need to be changed to True (instead of False).
sanity_checks = {

	# Did you make the change to the DIRECTORY value in docker-compose.yml?
	'make_changes_to_directory_entry_in_docker-compose.yml': False,

	# Does your directory entry in docker-compose.yml have a `:ro` suffix on it?
	'added_ro_suffix_to_docker-compose.yml_directory': False,

	# Did you update the DISPLAY value, if necessary, in docker-compose.yml?
	'changed_docker-compose.yml-display-value': False,

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
