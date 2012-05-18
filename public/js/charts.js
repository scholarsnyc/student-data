function drawLowestThirdPieChart(data, examType, targetDiv, width, height) {
  var dataTable = new google.visualization.DataTable();

  dataTable.addColumn('string', 'Grade');
  dataTable.addColumn('number', 'Students in the Lowest Third');
  dataTable.addRows([
    ['Grade 6', data[examType].six.lowestThirdCount],
    ['Grade 7', data[examType].seven.lowestThirdCount],
    ['Grade 8', data[examType].eight.lowestThirdCount]
  ]);

  var options = {'title':'Lowest Third: ' + examType.toUpperCase(),
                 'width':width,
                 'height':height};

  var chart = new google.visualization.PieChart(document.getElementById(targetDiv));
  chart.draw(dataTable, options);
};

function drawLowestThirdAverage(data, examType, targetDiv, width, height) {
  var dataTable = google.visualization.arrayToDataTable([
    ['Grade', 'Average for Lowest Third', 'Average For Whole Grade'],
    ['Six',  data[examType].six.lowestThirdAverage, data[examType].six.wholeGradeAverage],
    ['Seven',  data[examType].seven.lowestThirdAverage, data[examType].seven.wholeGradeAverage],
    ['Eight',  data[examType].eight.lowestThirdAverage, data[examType].eight.wholeGradeAverage],
  ]);

  var options = {
    title: 'Average Performance of Lowest Third: ' + examType.toUpperCase(),
  };

  var chart = new google.visualization.BarChart(document.getElementById(targetDiv));
  chart.draw(dataTable, options);
};