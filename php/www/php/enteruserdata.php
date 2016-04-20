<?php
	require_once( dirname(__FILE__) . '/db.php');
	DB::$connFile = '/home/timf/www/php/dbsettings.php';
	$db = DB::singleton();

	$id = $_POST[];

	$db->doQuery('INSERT INTO dbuser (id,name,sex,bday,hcolor,ecolor,body,city,hobbies)' .
		'VALUES ()');
?>