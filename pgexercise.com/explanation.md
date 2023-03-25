## Question
1 . How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).

![Schema](https://pgexercises.com/img/schema-horizontal.svg)

Here's a concept that some people find confusing: you can join a table to itself! This is really useful if you have columns that reference data in the same table, like we do with recommendedby in cd.members.

If you're having trouble visualising this, remember that this works just the same as any other inner join. Our join takes each row in members that has a recommendedby value, and looks in members again for the row which has a matching member id. It then generates an output row combining the two members entries. This looks like the diagram below:

![diagram](https://pgexercises.com/assets/innerjoin.png)

Note that while we might have two 'surname' columns in the output set, they can be distinguished by their table aliases. Once we've selected the columns that we want, we simply use DISTINCT to ensure that there are no duplicates.

