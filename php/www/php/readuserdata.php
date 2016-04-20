<?php
	require_once( dirname(__FILE__) . '/db.php');

	function getuserdata($id) {
		DB::$connFile = '/home/timf/www/php/dbsettings.php';
		$db = DB::singleton();
		$res = $db->doQuery("SELECT *,EXTRACT(year FROM age(bday)) as age FROM dbuser WHERE id = $id");
		$row = pg_fetch_array($res);
		echo "$row[id]: $row[name]($row[sex])<br>\n Alter: $row[age]<br>\n Größe: $row[size]<br>\n Haarfarbe: $row[hcolor]<br>\n Augenfarbe: $row[ecolor]<br>\n Statur: $row[body]\n";
	}

	getuserdata(455);  
?>