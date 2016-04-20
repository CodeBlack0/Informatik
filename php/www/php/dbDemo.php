<html>
	<head>
		<title>Tim's page</title>
		<meta charset="UTF-8">
		<link rel="stylesheet" type="text/css" href="../style.css">
	</head>
	<body>
		<div class="floater_top">
			<header class="banner">
				<h1>PHP DB Demo</h1>
			</header>
			<nav>
				<ul>
					<li><a href="http://timf.informatik-sgh.de">back</a></li><li>
					<a href="http://musil.informatik-sgh.de">Informatik</a></li><li>
					<a href="#top">Top</a></li>
				</ul>
			</nav>
		</div>
		<main>
			<a Name="top" class="top_mark"></a>
			<section>
				<h2>Users</h2>
					<?php
						require_once( dirname(__FILE__) . '/db.php');

						DB::$connFile = '/home/timf/www/php/dbsettings.php';

						$db = DB::singleton();

						$res = $db->doQuery('SELECT *,EXTRACT(year FROM age(bday)) as age FROM dbuser');
						while(($row = pg_fetch_array($res)))
						{
							echo "<article><a Name=$row[id]></a><h3>$row[id]: $row[name] ($row[sex])</h3>\n Alter: $row[age]<br>\n".
								 " Größe: $row[size]<br\n> Haarfarbe: $row[hcolor]<br>\n Augenfarbe: $row[ecolor]<br>\n".
								 " Statur: $row[body]\n</article>";
						};
					php?>
			</section>
		</main>
	</body>
</html>
