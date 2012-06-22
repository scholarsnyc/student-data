(function(){
	google.load('visualization', '1.0', {'packages':['corechart']});
	google.setOnLoadCallback(drawCharts);
	
	function drawCharts (){
	$.getJSON('/api/lowest-third', function(dataSet) {
		drawLowestThirdPieChart(dataSet, 'ela', 'ela_chart', 470, 300);
		drawLowestThirdPieChart(dataSet, 'math', 'math_chart', 470, 300);
		drawLowestThirdAverage(dataSet, 'ela', 'ela_bar', 470, 400);
		drawLowestThirdAverage(dataSet, 'math', 'math_bar', 470, 400);
	})
	};
	
	$(document).ready(function(){
		$('table tbody tr > td').each(
			function(i,e){
			var value = $(e).text()
			if (value < 0) {
				$(e).css('color', 'red')
			} else if (value > 0 && value < 50) {
				$(e).css('color', 'green')
			}
			}
		);
	});
})();