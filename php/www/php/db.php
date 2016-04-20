<?php

/**
* @brief Diese Klasse handhabt die Zugriffe auf die Datenbank.
*
* Das PHP-Programm soll nur einmal mit der Datenbank verbinden. Wenn die Verbindung steht, können beliebig viele DB-Anfragen darüber erfolgen. Da jede Instanz der Klasse ihre eigene Verbindung zur Datenbank aufbauen 
* will, muss sicher gestellt werden, dass im gesamten Programm nur eine einzige Instanz erzeugt wird. Diese muss von jeder Stelle des Programms benutzbar sein. Kurz: Das ist der klassische Fall für sog. Singletons.
*
* Benutzung der Klasse:
* @code
* $db = DB::singleton();
* $res = $db->doQuery('SELECT id,nick FROM reguser');
* while(($row = pg_fetch_array($res)))
* {
* 	//tu was mit $row['id'] und $row['nick'];
* };
* @endcode
*
* Die statische Methode singleton() sorgt intern dafür, dass eine Instanz der Klasse erzeugt wird, falls es noch keine gibt, oder sie gibt die bereits erzeugte Instanz zurück. Obiger Code kann also an vielen
* Stellen des Programms benutzt werden, ohne dass man sich um die eigentliche Erzeugung der Instanz kümmern müsste.
*
* Die Zugangsdaten für die DB-Verbindung werden in einer separaten PHP-Datei erwartet, die typischerweise außerhalb des www-Ordners liegt. In dieser Datei werden einfach nur folgende PHP-Variablen mit Werten belegt:
* @code
* <?php
* $wlDbHost = 'localhost';
* $wlDbName = 'dbmusil';
* $wlDbUser = 'musil';
* $wlDbPassword = 'GEHEIM';
* $wlDbSchema = 'forum12';
* @endcode
* Die Variable $wlDbSchema ist optional und nur dann von Bedeutung, wenn die DB-Tabellen nicht im Schema 'public' liegen. Wenn du das nicht verstehst, brauchst du $wlDbSchema wahrscheinlich nicht.
*
* Der Pfad (relativ oder absolut) zur Konfigurationsdatei muss vor dem ersten Aufruf von singleton() gesetzt werden. Das geht so:
* @code
* DB::$connFile = 'pfad/zur/config-Datei.php';
* @endcode
*/
class DB
{
	public static $connFile;
	private static $inst;
	private $conn;


	protected function __construct()
	{
	}

	/**
	* Gibt die einzige Instanz der Klasse zurück. Erzeugt sie, falls noch keine existiert.
	* @return Die einzige Instanz der Klasse, hat bereits Verbindung zur DB hergestellt.
	*/
	public static function singleton()
	{
		if( ! isset( self::$inst))
		{
			self::$inst = new self;
			self::$inst->connectToDb();
		};

		return self::$inst;
	}

	/**
	* Sendet eine Anfrage an die DB und gibt das Ergebnis zurück.
	* @param $query string Eine SQL-Query. Genau das, was man auch interaktiv über Putty eintippt.
	* @return Ein spezielles Ergebnis-Objekt. Ist für uns nur bei SELECT-Queries interessant.
	*/
	public function doQuery( $query)
	{
		$res = pg_query( $this->conn, $query); 		/* Die eingebaute PHP-Funktion pg_query führt die Query auf der Datenbank aus und liefert das Ergebnis zurück.*/

		if( !$res)
		{
			exit(1);
		};

		return $res;
	}

	/**
	* Braucht wahrscheinlich kein Mensch.
	*/ 
	public function mkPsqlCmd()
	{
		include( $this->ensureConnFile());
		return "psql $wlDbName";
	}

	protected static function ensureConfFile()
	{
		if( !isset( self::$connFile))
		{
			self::$connFile = dirname(__FILE__) . '/dbsettings.php';
		};

		return self::$connFile;
	}

	/**
	* Verbindet zur Datenbank, falls noch keine Verbindung besteht. Wirft einen Fehler auf, wenn keine DB-Verbindung möglich ist.
	*/
	protected function connectToDb()
	{
		if (isset( $this->conn)){ return;}; 		/* wenn schon verbunden ist, d.h. wenn conn schon gesetzt ist, dann ist nichts zu tun. */

		include( $this->ensureConfFile()); 	        /* die datei dbsettings.php einbinden, in der die benötigten Variablen zum Verbinden mit der Datenbank stehen */
		$this->conn = pg_connect("host=$wlDbHost dbname=$wlDbName user=$wlDbUser password=$wlDbPassword");
		if( !$this->conn)
		{ 
			echo "Kann nicht zur Datenbank verbinden.";
			exit(1);
		};
		if( $wlDbSchema )
		{
			$this->doQuery( "SET search_path TO $wlDbSchema");
		};
	}
}
