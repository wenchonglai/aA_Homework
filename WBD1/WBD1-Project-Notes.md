repo should be, on the top level, a rails app. rails app should not be under a directory
make advisor a collaborator
- manage access - invite a collaborator

# Sample Repo
- _https://github.com/appacademy/bluebird/wiki_

# MVP
- the MVPs of the project should be a full-stack app
  - hosing on Heroku (±1 day)
  - User Authentication (±2 days)
  - Production README (last, ±0.5 days)
  - 4 other from the MVP list (total of 7)

# MVP List as a design doc

### MVP List
- the order plan on implementing features
  - with detailed sub points
- include expected time to implement
  - be generous with the time estimates
- one feature must be a full CRUD cycle
  - 2 days for major features (posts, comments, users, etc)
  - 1 day for minor features (likes, follows, profiles, etc.)
  - include bonus (stretch) features that you will implement given enough time

# Wiki
- All design docs should get into the wiki page

# Database Schema
- tables
- name of cols and data types
- validations and indices
- *this can change*
- style
  - written in table format
  - table name's are `back_ticked`
  - table header column names are **bolded**
  - column names are lower_cased and snaked_cased and `back_ticked`
- sample
  `table_name`
  |col name| data type| details|
  |-|-|-|
  |id|integer|not null, primary key|
  |username|string|not null, indexed, unique|


# ActiveStorage is coming
- no image_urls saved in database
- but we do need them on the frontend

# Due WBD2
- Github Repo
- Add PA
- MVP List
- Schema tables in md
- updated project repo's wiki page

# Useful Links
- table making:
  _https://www.tablesgenerator.com/markdown_tables_
- md format:
  _https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet_
- sample wiki:
  _https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet_