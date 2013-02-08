$(document).ready(function() {
  
  $('#student-selector').select2();
  $('#course-selector').select2();

  // Tablesorter Defaults
  $("table#student-index").tablesorter( {sortList: [[1,0]] } ); 
  $("table#course-index").tablesorter( {sortList: [[0,0]] } ); 
  $("table#probation-index").tablesorter( {sortList: [[1,0]] } ); 

  var studentRows = $('table#student-index > tbody tr'),
      filterButtons = $('div#grade-filter button');

  filterButtons.on('click', function (e) {
    var activeRows, inactiveRows, grade = $(this).data("grade");
    e.preventDefault();
    if (grade === "all") {
      studentRows.show();
    } else {
      activeRows = studentRows.filter(function () {
        return $(this).data("grade") === grade;
      });
      inactiveRows = studentRows.filter(function () {
        return $(this).data("grade") !== grade;
      });
      activeRows.show();
      inactiveRows.hide();
    }
  });
});
