Development Documentation
=========================

For Example:

	chm = "<a>,<opt_b>,<c>,<opt_d>,<opt_e>"
	chm = "a,opt,12,opt2"
	chm = "a,,12,"  # this is valid. can be get by ['a', nil, 12, nil].join(',')
	chm = "a,,12,," # this is not valid

	recommand use chm = "a,<default_value>,12", if you omit <opt_b>, http://imagecharteditor.appspot.com/#Import chart from URL not work


Resources
---------
* [Google Chart API](http://code.google.com/apis/chart/docs)

