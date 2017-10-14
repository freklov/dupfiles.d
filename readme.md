# dupfiles.d - identify duplicate files on Mac OS
## Background
After copying lots of documents to a software and folder structure, I want to make sure that I really caught every single document in the old structure and have it somewhere in the new structure.

Two additional challenges:
1. Names of the documents could have changed
2. Names of the files could appear more than once, but in different folders and with different content 

## Duplicate Finder Software
I tried some of the available duplicate finders available in the Mac OS store, but they did not meet my simple requirements:

* Compare old folder structure with the new folder structure and remove those files from the old folder structure that are identical to a file in the new folder structure
	
To be more precise: Each of  the duplicate finder software that I tried offered a possibility to meet my requirement in some kind, but only with huge effort or not with comprehensible results.

## Back to the roots
Open a terminal and compare the files manually.

* Use *find* and *shasum* to identify the files in a folder structure
* Use *grep* to identify files that already exist in the the folder structure 
* Generate a list with files to remove

My working effort for 20.000 files was much less than the time that I previously used to evaluate the duplicate finder software. However,  the overall execution time was over 24 hours because the scripting (especially the *grep* command that extracted the files to be deleted) was very insufficient.

But overall it was a success, because I was not really in a hurry to get the comparison done und the computer’s processing time was not my personal time.

## dupfiles
Since this manual scripting was very helpful to me, I decided to package the functionality into *bash* scripts  and to rewrite the code a little bit to boost performance.

### Setup
1. Copy the files into a folder, e. g. *$HOME/dupfiles.d*.
2. Edit the file *dupfiles.setenv* , and update *DUPFILESROOT* if required.
3. Open a terminal and go the your folder
4. Source the file „dupfiles.setenv“

`. ./dupfiles.setenv`


#### Folder structure
After sourcing of „dupfiles.setenv“ you should see the following structure:

```
dupfiles.d
dupfiles.d/bin
dupfiles.d/db
```

* **bin:** Contains the executable *bash* scripts
* **db:** Database folder containing the files required for comparison. This folder is empty after the installation.

#### Commands
* **dfsum.sh** \<schema> \<table> \<directory>
	* creates a file \<schema>.\<table> in directory ${DUPFILESDB}. The file contains the checksum and full path of each file in <directory> and subdirectories.
* **dflist.sh** [schema]
	* lists all files with name \<schmea>.* in directory ${DUPFILESDB}.
* **dfcompare.sh** \<schema> \<table1> \<table2>
	* compares the files \<schema>.\<table1> (masters) with \<schema>.\<table2> (duplicates) in directory ${DUPFILESDB}, and creates a file \<schema>.DUPFILES in directory ${DUPFILESDB}. The file \<schema>.DUPFILES contains a list with files that exist in 'duplicates' and in 'masters' and have the same checksum in 'duplicates' and in 'masters'.
* **dfcmd.sh** \<schema> \<command>
	* creates a file \<schema>.execute.\<cmd>.sh in current working directory. The file contains one command <command> per file listed in \<schema>.DUPLICATES in directory ${DUPFILESDB}.
* **dfclean.sh** \<schema> 
	* deletes all files with name \<schmea>.* from directory ${DUPFILESDB}.

#### How it works
You can use *\<schema>*  to group your duplicate searches by a specific name.

Assumption: You have a folder named „my current“ which is the folder that contains the files you want to keep.  The second folder „my collections“ contains some of the files of „my current“, as well as additional files. You want to eliminate the duplicate files from the „my collections“. folder.

```
dfsum.sh doubles my_current „$HOME/my current“
dfsum.sh doubles my_collections „$HOME/my collections“
dfcompare.sh doubles my_current  my_collections
dfcmd.sh doubles „ls -l“
```

Execute the file doubles.execute.ls.sh in your current working directory. 

`sh doubles.execute.ls.sh`

**NOTE:** The files do not automatically interrupt if an error occurs. Be always careful with the results. Backup your files before deleting it. I strongly recommend to run a full backup of your computer before working with dupfiles.d.

 
