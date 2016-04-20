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
                            $db = DB::singleton();
                $mode = isset($_COOKIE['datbook-mode']) ? $_COOKIE['datbook-mode'] : 'login';
                $userid = isset($_COOKIE['datbook-current-id']) ? $_COOKIE['datbook-pasword'] : 0;
                $mode = 'login';

                echo "<br><br><p>$mode : $userid</p><br><br>";

                switch ($mode) 
                {
                    case 'std':
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
                    
                    case 'login':
                        echo "
                        <section>
                            <article>
                                <form action='index.php' method='post'>
                                    <pre><p>Username: <input name='datbook-name' type='text'></p></pre>
                                    <pre><p>Pasword:  <input name='datbook-pasword' type='password'></p></pre>
                                    <br><<input type='submit'>
                                </from>                                    
                            </article>
                        </section>";
                        setcookie('datbook-mode','login-eval');
                        break;

                    case 'login-eval':
                        $name = $_REQUEST['datbook-name'];
                        $psswd = $_REQUEST['datbook-pasword'];
                        $res = $db->doQuery("SELECT * FROM credentials WHERE username = $name AND psswd = $password");
                        $row = pg_fetch_array($res);
                        if(isset($row))
                        {
                           setcookie('datbook-current-id',"$row[id]");
                           setcookie('datbook-mode','std');
                        }
                        break;

                    default:
                        setcookie('datbook-mode','login');
                        break;
                }
            ?>
        </main>
    </body>
</html>