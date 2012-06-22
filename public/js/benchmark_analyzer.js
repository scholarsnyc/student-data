(function () {
   var pullData = function (grade, subject) {
     'use strict';

     var courses = {
      ela: "English",
      library: "Library",
      math: "Mathematics",
      media: "Media Arts",
      music: "Music",
      newspaper: "Newspaper",
      gym: "Physical Education",
      science: "Science",
      socialstudies: "Social Studies",
      spanish: "Spanish",
      tech: "Technology",
      art: "Visual Art"
     }

     $('#cep-data').html('<div class="alert alert-block"><h4>Loading...</h4><p>We are pulling your information in from the database, this should only take a second or two.</p></div>');
     $.getJSON('/api/cep/grade/' + grade + '/subject/' + subject, function (data) {
       
       var identifier = 'cep-benchmark-data-' + data.subject + data.grade;
       var report = $('<div id="' + identifier + '">')
         .addClass('cep-report')
         .addClass('grade' + data.grade)
         .addClass(data.subject);

       $('<h2>Grade ' + data.grade  + ': ' + courses[data.subject] + '</h2>').prependTo(report);

       var createCohortTable = function (i, c) {
         var element, table;
         element = $('<div></div>')
           .append('<h3>' + c.cohort + ': Average Benchmark by Marking Period</h3>');

         table = $('<table class="table table-bordered table-striped table-condensed tablesorter cep-subject-breakdown">\
         <thead>\
         <tr>\
         <th>Group</th>\
         <th>Exam Average</th>\
         <th>Predictive Average</th>\
         <th>Predicted Progress</th>\
         <th>T1MP1</th>\
         <th>T1MP2</th>\
         <th>T1MP3</th>\
         <th>T2MP1</th>\
         <th>T2MP2</th>\
         </tr>\
         </thead>\
         <tbody>\
         </tbody>');

         $.each([c.wholeGrade, c.lowestThirdELA, c.lowestThirdMath], function (index, group) {
           var row = $('<tr>');
           row.append('<td class="group-name">' +  group.groupName + '</td>');
           row.append('<td class="exam-average">' +  (group.examAverage || '') + '</td>');
           row.append('<td class="predictive-average">' +  (group.predictiveAverage || '') + '</td>');
           row.append('<td class="predictive-state-comparison">' +  (group.comparePredictiveToState || '') + '</td>');
           $.each(group.benchmarkByMarkingPeriod, function (index, mp) {
             row.append('<td class="mp' + mp.mp  + '">' + (mp.score || '') + '</td>')
           });
           row.appendTo(table)
         });

         element.append(table).appendTo(report);
       }

       $.each(data.cohorts, createCohortTable);

       $('#cep-data').text('').append(report);
     });
   };
   
   
   $('document').ready(function () {
     $('#pull-cep-data').submit(function (event) {
        event.preventDefault();
        pullData($('#select-grade').attr('value'), $('#select-subject').attr('value'));
      });
   });
 })();