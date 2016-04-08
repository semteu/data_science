## variables ##

variable name | meaning
--- | ---
__test_data__ | test data.frame object read from file
__train_data__ | train data.frame object read from file
__activity__ | the 6x2 data.frame object containing the mapping of activities names
__data__ | the 10299x563 data.frame object containing combined data, the first column is the subjects and second column is the integers indicating the activity
__features__ | the 561x2 data.frame object containing the mapping of feature names 
__mean_std_data__ | the 10299x68 data.frame object containing mean and standard derivation columns, the first column is the subjects and second column is the integers indicating the activity
__labelled_data__ | similar to mean_std_data, except that the activities in the second column are in strings labels instead of numbers
__result__ | a 180x68 data.frame object, which is the final data required
