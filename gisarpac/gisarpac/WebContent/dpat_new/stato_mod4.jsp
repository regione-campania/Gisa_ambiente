<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>


<script type="text/javascript" src="jquery.miny_1.7.2.js"></script>
<script src="jquery-ui.js" type="text/javascript" ></script>

<link rel="stylesheet" type="text/css" href="theme.css"></link>
<link rel="stylesheet" type="text/css" href="jquery.tablesorter.pages.css"></link>
<script type="text/javascript" src="jquery.tablesorter.js"></script>
<script type="text/javascript" src="jquery.tablesorter.pager.js"></script>
<script type="text/javascript" src="jquery.tablesorter.widgets.js"></script>

<script>


$(function(){
	
	 var pagerOptions = {
			    // target the pager markup - see the HTML block below
			    container: $(".pager"),
			    // output string - default is '{page}/{totalPages}'; possible variables: {page}, {totalPages}, {startRow}, {endRow} and {totalRows}
			    output: '{startRow} - {endRow} / {filteredRows} ({totalRows})',
			    // if true, the table will remain the same height no matter how many records are displayed. The space is made up by an empty
			    // table row set to a height to compensate; default is false
			    fixedHeight: true,
			    // remove rows from the table to speed up the sort of large tables.
			    // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
			    removeRows: false,
			    // go to page selector - select dropdown that sets the current page
			    cssGoto: '.gotoPage'
			  };

	 $("#tableSDC")
	 .tablesorter({
			theme: 'blue',
			headerTemplate : '{content} {icon}', // new in v2.7. Needed to add the bootstrap icon!
			widthFixed: true,
			widgets: ['zebra', 'filter']
		}).tablesorterPager(pagerOptions);
	 


	});
</script>


<sql:setDataSource var="dm" driver="org.postgresql.Driver" url="jdbc:postgresql://172.16.0.3/gisa" user="postgres"  password=""/>

<html>
<style>
tbody tr:nth-child(odd) {
  background: #eee;
}
tbody tr:hover { /* th:hover also if you wish */
  background: yellow;
}
table, td, th {
    border: 1px solid #98bf21;
    vertical-align: middle;
    border-collapse: collapse;
    padding: 3px 7px 2px 7px;
}
th {
   background-color: green;
    color: white;
}
</style>
<body>
<h2> </h2>

<sql:query var="rm" dataSource="${dm}">
select case when stato=1 then 'APERTO'
WHEN stato=2 THEN 'CHIUSO'
when stato = 0 then 'CHIUSO-MODIFICATO'
ELSE '' end as stato ,asl.description,descrizione,id_asl
from dpat_strutture_asl sdc
join lookup_site_id asl on asl.code = id_asl  
where anno =2017 and tipologia_struttura=13
order by id_asl
</sql:query>

<h4>STATO AVANZAMENTO MODELLO 4</h4>

<%
boolean filter = true;

%>

<div class="pager">
		Page: <select class="gotoPage"></select>		
		<img src="javascript/img/first.png" class="first" alt="First" title="First page" />
		<img src="javascript/img/prev.png" class="prev" alt="Prev" title="Previous page" />
		<img src="javascript/img//next.png" class="next" alt="Next" title="Next page" />
		<img src="javascript/img/last.png" class="last" alt="Last" title= "Last page" />
		<select class="pagesize">
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="30">40</option>
			<option value="40">40</option>
			
		</select>
	</div>
	
<table id ="tableSDC" class="tableSorter">
  		<thead>
  			
  			
  			<tr class="tablesorter-headerRow" role="row">
		
<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="CERCA PER STATO" class="<%=(filter) ? "first-name filter-select" : "filter-false"%>"><div class="tablesorter-header-inner">STATO MODELLO 4</div></th>
<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="CERCA PER ASL" class="<%=(filter) ? "first-name filter-select" : "filter-false"%>"><div class="tablesorter-header-inner">ASL</div></th>
<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="CERCA PER STRUTTURA"  class="<%=(filter) ? "filter-match tablesorter-header tablesorter-headerUnSorted" : "filter-false"%>"><div class="tablesorter-header-inner">STRUTTURA COMPLESSA</div></th>
</tr>
	  		
  		</thead>
 		
 		<tbody aria-relevant="all" aria-live="polite">


			<c:forEach var="row" items="${rm.rows}"> 
                        <tr>
                         <td>   ${row.stato} </td>
			<td>   ${row.description} </td>

                          <td>   ${row.descrizione} </td>
                           
                        </tr>
                        </c:forEach>

                </tbody>
                </table>
<div class="pager">
		Page: <select class="gotoPage"></select>		
		<img src="javascript/img/first.png" class="first" alt="First" title="First page" />
		<img src="javascript/img/prev.png" class="prev" alt="Prev" title="Previous page" />
		<img src="javascript/img//next.png" class="next" alt="Next" title="Next page" />
		<img src="javascript/img/last.png" class="last" alt="Last" title= "Last page" />
		<select class="pagesize">
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="30">40</option>
			<option value="40">40</option>
			
		</select>
	</div>

