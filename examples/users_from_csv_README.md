ACHEHealth Folks,

Here's some documentation on how to use the users_from_csv.rb script to add users to your DSpace repository and add them to groups...

# Before you begin:
Your DSpace repository administrator (Brittany or someone in a similar role) should add any groups you want to assign users into. Depending on your needs, you could add users into separate Faculty, Staff and Student groups, then assign those groups as subgroups of an Affiliates group. Alternately, if you don't anticipate needing to differentiate to that level, you could instead assign all users directly into an Affiliates group. Either way, the group(s) in the import CSV should exist before running the script. This group can be assigned appropriate permissions within your repository either before or after the import. This document will not go into detail about these tasks, please let us know if you need assistence with these parts of the process.

# To run the script:
1) Clone this repository using the ACHEHealth branch:
```
# Open your terminal and navigate to your desired directory
cd /path/to/your/directory

# Clone the specific branch using git clone with the -b flag
git clone -b ACHEHealth https://github.com/dts-hosting/dspace-client/
```

2) Install ruby and bundler (ruby's included package manager):
https://www.ruby-lang.org/en/documentation/installation/

3) Install the prerequisites for the script:
```
bundle install
```

4) Populate the `users.csv` file (in the `examples` directory) with your user data. I'm not sure how the performance will be with large numbers of users, so you may want to split them into multiple files, if you need to import humdreds of them at a time. If it is arduous to populate the `groups` column, you can leave it off and instead modify the script to put everyone into the same group. Let us know if you need help doing that. The other fields (email, firstname, lastname) are required. DSpace won't know what to do with any additional fields you add to the file.

5) Run the script:
```
ruby examples/users_from_csv.rb
```

# Supplemental Documentation
There are lots of additional example scripts that use the `dspace-client` library in the `examples` directory:
https://github.com/dts-hosting/dspace-client/tree/main/examples
If you want to interact with the API more directly, all endpoints are documented here:
https://github.com/DSpace/RestContract/
...and here's the overview of the API in the DSpace Wiki:
https://wiki.lyrasis.org/display/DSDOC8x/REST+API