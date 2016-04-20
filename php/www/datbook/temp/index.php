<!DOCTYPE html>
<html lang="en">
    <head>
        <title>DatBook</title>
        <meta charset="UTF-8">
        <link rel="stylesheet" type="text/css" href="style.css">
        <!--[if lt IE 9]>
            <script>
                document.createElement("article");
                document.createElement("aside");
                document.createElement("footer");
                document.createElement("header");
                document.createElement("main");
                document.createElement("nav");
                document.createElement("section");
            </script>
            <![endif]-->
    </head>
    <body>
        <div class="floater_top">
            <header class="banner">
                <h1>DatBook</h1>
            </header>
            <nav>
                <ul>
                    <li><a href="http://timf.informatik-sgh.de" class="back">[back]</a></li><li>
                    <a href="#">test1</a></li><li>
                    <a href="#">test2</a>
                    <ul>
                        <li><a href="#">test1</a></li><li>
                        <a href="#">test2</a></li>
                    </ul></li>
                </ul>
            </nav>
            <aside>
                <h3>Contacts</h3>
                <ul>
                    <li><a href="#">Group A</a></li><li>
                    <a href="#">Group B</a>
                    <ul>
                        <li><a href="#">Person 1</a>
                        <ul>
                            <li><a href="#">Message</a></li><li>
                            <a href="#">Poke</a></li><li>                            
                            <a href="#">Unfriend</a></li>
                        </ul></li><li>
                        <a href="#">Person 2</a>
                        <ul>
                            <li><a href="#">Message</a></li><li>
                            <a href="#">Poke</a></li><li>                            
                            <a href="#">Unfriend</a></li>
                        </ul></li>
                    </ul></li><li>
                    <a href="#">Group C</a></li>
                </ul>
            </aside>
        </div>
        <footer>
            <ul>
                <li><a href="http://timf.informatik-sgh.de" class="back">[back]</a></li><li>
                <a href="#top" class="top">[top]</a></li><li>
                <a href="#">test1</a></li><li>
                <a href="#">test2</a>
                <ul>
                    <li><a href="#">test1</a></li><li>
                    <a href="#">test2</a></li>
                </ul></li>
            </ul>
        </footer>
        <main>
            <a Name="top" class="top_mark"></a>
            <?php
                require_once( dirname(__FILE__) . '/../php/db.php');
                DB::$connFile = '/home/timf/www/php/dbsettings.php';
                $mode = $_REQUEST['mode'];
                $userid = $_REQUEST['id'];

                if(isset($mode) || isset($userid)) 
                {
                    switch ($mode) 
                    {
                        case 'std':
                            $db = DB::singleton();
                            $res = $db->doQuery("SELECT * FROM news WHERE reciever = $userid ORDER BY id DESC");
                            while(($row = pg_fetch_array($res)))
                            {

                                $res_sendersearch = $db->doQuery("SELECT name FROM dbuser WHERE id = $row[sender]");
                                $sender = pg_fetch_array($res_sendersearch);
                                $res_recieversearch = $db->doQuery("SELECT name FROM dbuser WHERE id = $userid");
                                $reciever = pg_fetch_array($res_recieversearch);

                                echo "<section><p>From: $sender[name] | To: $reciever[name] | @$row[ts_sent]</p>".
                                "<article><a Name=$row[id]></a>$row[message]</article></section>";
                            };
                            break;
                        
                        default:
                            echo "<h3>invalid mode, unable to operate</h3><br>\n";
                            break;
                    }
                }
                elseif (isset($mode))
                {
                    echo "<h3>user not set, unable to operate</h3><br>\n";
                }
                elseif (isset($name))
                {
                    echo "<h3>mode not set, unable to operate</h3><br>\n";
                }
            ?>
        </main>
    </body>
</html>