Linux Tutorial
==============

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

This assignment is a tutorial for how to use Linux.  It introduces the basic commands that you will need to know to navigate in a Linux environment.  This assignment does not go over Docker commands, which were presented in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)).

If you already know Linux, then you can just browse through this assignment to ensure that you are familiar with all the material presented.  The commands we expect you to know are listed below.

You will be submitting an edited version of the [linux.py](linux.py.html) ([src](linux.py)) file.

This assignment has very little in terms of the deliverable -- in fact, you could easily skip to the 'Submission' section, make up answers, and get full credit on this assignment.  **HOWEVER,** this assignment is going to be necessary to complete before doing *any other* assignment in this course.  The material gone over in this tutorial are also fair game for pop quizzes and exams.


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  So far there aren't any significant changes to report.


### Tutorial

The goal of this tutorial is for you to feel more comfortable with Linux.  We would expect that you would have some knowledge of the following commands:

- Basic commands: `man`, `clear`, `whoami`
- Directory commands: `ls`, `mkdir`, `rmdir`, `cd`, `pwd`
- Working with files commands: `touch`, `rm`, `cp`, `mv`, `rename`
- File content commands: `head`, `tail`, `cat`, `less`, `echo`, `wc`, `grep`
- I/O redirects: `<`, `>`, `>>`, `|`

Some of them are more important (`ls`, `cd`), some less important (`wc`, for example).  But you should have seen them all to some extent.

If you are familiar with Linux, just be sure you know the commands listed above.

#### Tutorial

[This tutorial](https://www.freecodecamp.org/news/linux-command-line-tutorial/) is one we recommend.  It is your typical tutorial -- read through it, and try out the commands in your Docker image.  Note that only the second half of the sections are relevant:

- [Linux commands to run in the terminal](https://www.freecodecamp.org/news/linux-command-line-tutorial/#basic-linux-commands-to-run-in-the-terminal)
- [How to work with directories in Linux](https://www.freecodecamp.org/news/linux-command-line-tutorial/#how-to-work-with-directories-in-linux)
- [Commands to work with files in Linux](https://www.freecodecamp.org/news/linux-command-line-tutorial/#commands-to-work-with-files-in-linux)
- [Commands to work with file contents](https://www.freecodecamp.org/news/linux-command-line-tutorial/#commands-to-work-with-file-contents)
- [Linux command operations](https://www.freecodecamp.org/news/linux-command-line-tutorial/#linux-command-operations)

As you learn the commands, you should try them out in the Docker containers.  How to start the containers, and then connect to them, is described in the [Docker configuration assignment](../docker/index.html) ([md](../docker/index.md)).

You are welcome to try out other tutorials, including video tutorials.  If you like to learn by playing games, check out [Bandit](https://overthewire.org/wargames/bandit/).  But if you do use other tutorials, check that you have learned the commands above.  If you missed one or two, enter `man <cmd>` into your favorite search engine, and learn how to use the command from the manual page.


### Submission

You will be submitting an edited version of the [linux.py](linux.py.html) ([src](linux.py)) file.  The comments therein explain what values you should fill in.  We are interested in honest answers, not [sycophantic](https://www.merriam-webster.com/dictionary/sycophantic) answers.  The assignment is auto-graded, so you will get full credit as long as you fill in the values in that file correctly.

That file is the only file you should submit to Gradescope.

