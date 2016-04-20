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
				<h2>Länder</h2>
					<article>
						<?php
							$land_hauptstadt = array(
								'Deutschland' => 'Berlin',
								'England'     => 'London',
								'Frankreich'  => 'Paris',
								'Niederlande' => 'Amsterdam',
								'China'       => 'Peking',
								'USA'         => 'Washington',
								'Bhutan'      => 'Timphu',
								'Lesotho'     => 'Maseru',
								'Niger'		  => 'Niamey',
								'Vatikan'     => 'Vatikan'
							);

							$land_einwohnerzahl = array(
								'Berlin'      => '80.620.000',
								'London'      => '53.010.000',
								'Paris'       => '66.030.000',
								'Amsterdam'   => '16.800.000',
								'Peking'      => '1.357.000.000',
								'Washington'  => '318.900.000',
								'Timphu'      => '753.947',
								'Maseru'      => '2.074.000',
								'Niamey'      => '17.830.000',
								'Vatikan'     => '798'
							);

							foreach ($land_hauptstadt as $land => $stadt) {
								echo $land ."'s Hauptstadt ist ". $stadt .' und es hat '. $land_einwohnerzahl[$stadt] . " Einwohner. <br>\n";
							}
						?>
					</article>
			</section>
		</main>
	</body>
</html>