Web of Trust
============

[Go up to the NWS HW page](../index.html) ([md](../index.md))

### Overview

How do you know who to trust? How do you know they are who they say they are? Your goal in this project is to learn about public key cryptography, gpg, verifying identities, and the web of trust. You will need to:

1. Create a GPG public/private keypair
2. Register your public key with the submission server; you will be given a fake key
3. Get your valid key signed by 15 of your fellow students in this class
4. Avoid signing any fake keys (you will need to verify your classmate's identity), and avoid getting your valid key signed by any fake keys
5. Try to get people to accept a signature from your fake key

You should read the entire assignment before getting started. You may wish to think about a strategy that will help you convince others to sign your fake key or to sign their valid key with your fake key.

**Important:** Do not upload either of your keys to any public keyserver. It would be unethical for this class assignment to pollute the information on these public resources. We will search the keyservers for your public keys, and if we find them, **you will receive zero points.** If you upload your key to a public key server by accident, you must contact the instructor immediately.

This assignment has *two* due dates:

- Earlier due date: parts 1 through 3 needs to be completed by the earlier due date, which is one week before the later due date.  You will need to submit your GPG public key, and send an email, by this date.
- Later due date: the rest of the assignment is due by the date specified on the Canvas landing page.  You will need to submit your (signed) GPG keys, and the edited [weboftrust.py](weboftrust.py.html) ([src](weboftrust.py)) by this due date.

**Acknowledgements:** This assignment was based, with permission, on [this one](https://people.csc.ncsu.edu/whenck/csc474/f23/ex/wot.html) by [William Enck](https://www.csc.ncsu.edu/people/whenck), who derived his (with permission) from an assignment created by [Adam Doupé](https://adamdoupe.com).


### Changelog

Any changes to this page will be put here for easy reference.  Typo fixes and minor clarifications are not listed here.  <!-- So far there aren't any significant changes to report. -->

- Sun, Feb 25: Updated weboftrust.py](weboftrust.py.html) ([src](weboftrust.py)), specifically the fields in the `other` and `sanity_check` dictionaries.  If you downloaded the previous version, then: change the number 30 in the `sanity_checks` dictionary to 15 (4 occurrences), and add the 2nd to last field in the new version in the `other` dictionary.


### Part 1: Generate a GPG Key

You will need to install [GPG](https://gnupg.org), the Gnu Privacy Guard -- this is an RSA client for encrypting emails.  Installation packages can be found toward the bottom of [this page](https://gnupg.org/download/index.html); there are GUI versions for the major operating systems.  If GPG is already installed with your email client, that's fine -- you don't need to install it again.  It is also installed on the course Docker image, but you may not want to use the command-line version.

**You MUST create a 4096 bit RSA key!**  This is what the adversarial key will be (see below for that), and if yours is different (3072 bits, for example), then it will be easy to differentiate them.

Create a public/private GPG keypair specifically for this project with the following requirements:

1. The name is your formal name.  It should match what is on your UVA ID card.  If you go by a middle name, nickname, etc., you can include that in addition to what's on your UVA ID card.  And if your UVA ID card has an initial for your first name, please include the full name and not just the initial.
2. The email address ***MUST*** be your formal UVA email address in the form mst3k@virginia.edu
3. **Does not** have a comment

Other students will need to verify your identity, so the name and email must be exact. This will be automatically checked by GradeScope in Part 2, so for the purposes of this assignment, your name is what GradeScope thinks your name is.

There are many guides for creating a GPG keypair, including information in the `man` page for the command. I recommend GitHub's guide for [generating a new GPG key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-gpg-key).

**Important note for existing GPG users:** If your existing key is with your formal UVA email address (mst3k@virginia.edu), then you should **NOT** use that one, and creating a second key with the same exact email address causes problems.  You should add `+nws` to the end of your userid as such: `mst3k+nws@virginia.edu`.  Note that you can, in general, add anything after your username and a `+`; we are just going to use `+nws` for this assignment.


#### -- DO NOT LOSE YOUR KEYPAIR --

I cannot stress this enough, due to the nature of the assignment, we **cannot** and **will not** sign multiple keys for you. This may result in you getting **a zero** on the assignment. [Backup your keypair](https://www.phildev.net/pgp/gpg_moving_keys.html). Because the keypair is being used for only this assignment, it is not as critical to keep it safe as if it were your normal RSA key -- thus, you can just email the keys (both public and private) to yourself.  If you lose the key once you've uploaded it to the server, then you will not be able to finish the assignment. Every UVA student has storage in Box, and you can use that as well -- or any other mechanism to backup your keypair (including your secret key). Once your key is generated, backup your public and private key. Seriously, you've been warned.

#### -- DO NOT LOSE YOUR KEYPAIR --


### Part 2: Upload Your Public Key

Save your public key as a file called `mst3k.gpg`, where `mst3k` is your userid, and then upload your public key to GradeScope to the assignment "Web of Trust Upload". The server will then check to see if your public key is valid, and only if it is, the server will sign your public key with the [course's keypair](nws-key.pub), which has a fingerprint of `FDA0 7EF5 8A87 1F57 9D6D  56DA 23AD 0D8A 73E5 7217`. You should download this key, verify the fingerprint, and import it into your GPG keyring.

The server will also generate an *adversarial* keypair with a random name of **another student in the class** and the **same email as your key**. You will be able to download this adversarial keypair (both the public and private key).

As this is signing your key, you may only upload your key **ONCE**.  The system will not sign a second keypair for you, as that means you lost your original keypair.  Note that a failed submission (wrong files submitted, incorrect format, etc.) will not count as the one time upload.

This part, along with the next part, are due by the earlier due date.


### Part 3: Send an Email

You need to send an RSA encrypted email to the course email address, which is listed on the Canvas landing page.  In it, you should request your secret code.  Include some witty or interesting quote.  Both the request and the quote should be encrypted via GPG and the [course's keypair](nws-key.pub).

**Note:** If you have the ability to choose the file name of the encrypted file, such as if you are doing it as an attachment, please name it `mst3k.txt.gpg`.  If you don't have the option to name it (it's cut-and-pasted), that's fine.

You need to send this email by the earlier due date (one week before the later due date).

You will receive a response back with a code specific to your userid; this code will need to be included in the [weboftrust.py](weboftrust.py.html) ([src](weboftrust.py)) file that you submit.  Note that this will take us some time to respond!  There are a lot of students in the class.  However, as long as you sent your email by the earlier due date, you will receive your response no later that 24 hours before the later due date.

This part (just the sending of the email), and the previous part (uploading your key), are due by the earlier due date.


### Part 4: Get Your Key Signed

Here's where the fun starts. You need to get your key signed by at least 15 of your fellow students' public keys. The signatures must be from a **valid** key in this class: How will you know?

**Note:** For the purposes of this assignment, a "valid" key is a key created by one of your classmates and signed by the class signing key. The adversarial keys created by GradeScope are **not** "valid" keys.  Signatures from invalid keys do not count toward the 15 total

There are lots of resources on the Internet that describe signing public keys. Here are two that focus on the command line versions:

- [GPG manual](https://www.gnupg.org/gph/en/manual/x56.html)
- [Another guide](http://www.phillylinux.org/keys/terminal.html)

That being said, the GUIs for GPG are pretty easy to use, and you probably can figure out how to sign a key by tinkering around.


### Part 5: Sign Other Keys

Using what you learned from the above, you must sign at least 15 of your fellow students' public keys. You are encourage to sign more, but only public keys valid for this class count: *How will you know?*

A big part of this assignment is figuring out how to determine if the key you are signing is actually the correct key for the person you think it is.

**Note:** We will only count signatures from your **valid key** on other students' valid keys. That is, signing other students' valid keys with your adversarial key will not count towards your required number if signatures. Similarly, signing someone else's adversarial key with your valid key will not count toward your required number of signatures.


### Grading

**Note:** The goal of this assignment is to (1) have you send and receive a PGP encrypted email, and (2) get a feel for how hard it is to know who and what to trust.  The goal is not to have you feel annoyed or angry at your fellow students if you end up being fooled.  So the deductions for that are going to be quite small.  I want people to come away from this assignment having learned something, uncomfortable though it may be to learn how hard it is to know who to trust.  Having you come away bitter and angry at myself, this assignment, or your fellow students does not help achieve that goal.  So don't stress to much about the point deductions.

- The base grade is determined by:
	- You have signed 15 other keys 											(your valid signing their valid)
	- You have 15 *valid* signatures on your keys (either valid or invalid)		(their valid signing your valid)
- The following will cause deductions from the base grade:
	- Number of invalid signatures on your valid key 							(their invalid signing your valid)
	- Number of invalid keys you signed with your valid key 					(your valid signing their invalid)
- An extra credit bonus will be awarded for:
	- Signing other people's *valid* keys with your *invalid* key 				(your invalid signing their valid)
	- Getting your *invalid* key signed with another student's *valid* key 		(their valid signing your invalid)
- A signature of an invalid key with another invalid key cancels out, and no points are awarded or deducted:
	- Signing another invalid key with your invalid key  						(your invalid signing their invalid)
	- Getting your invalid key signed with another invalid key 					(their invalid signing your invalid)
- Not sending the email, or sending it late, will be some sort of deduction

Note that signing one of your keys (either one) with your other key will not affect your grade.  Also note that signing one or two invalid keys with your own will not sink your grade!

The exact amount of points will be determined at the end, once we see the results.  This is for both the deductions and the extra credit bonus.

### Submission

There are TWO submissions for this assignment, with different due dates; the second one is due a week after the first one.

#### First submission

The first is to the "Web of Trust Upload" assignment in Gradescope, which is where you upload your key created in part 1, and this submission is described in part 2.  The file should be named `mst3k.pub`, where `mst3k` is your UVA userid.  You also have to send the GPG encrypted email to the course email address.

#### Second submission

The second is to the "Web of Trust Submission" assignment in Gradescope, where you are submitting your public key (with the 15 signatures), which you will need to export into a `mst3k_signed.pub` file.  Also submit your public adversarial key (whether you tricked people into signing with your adversarial key or not) into a `mst3k_fake.pub` file.

You will also need to submit an edited version of [weboftrust.py](weboftrust.py.html) ([src](weboftrust.py)); that file explains what to fill in and where.
