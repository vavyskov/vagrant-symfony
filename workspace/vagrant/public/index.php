<?php

// Memcached
$memcached_version = false;
/*$m = new Memcached();
if ($m->addServer('localhost', 11211)) {
	$memcached_version = $m->getVersion();
	$memcached_version = current($memcached_version);
}*/

// External access
/*echo
  $_SERVER['SERVER_ADDR'] .' | '.
  gethostbyname($_SERVER['SERVER_NAME']) .' | '.
  $_SERVER['SERVER_NAME'] .' | '.
  gethostname() .' | '.
  gethostbyaddr($_SERVER['REMOTE_ADDR']);*/

?>

  <!doctype html>
  <html lang="en">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Vagrant (public folder)</title>

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css">
    <style>
      .container {
        max-width: 50em;
      }
      td:first-child {
        width: 40ch;
      }
    </style>
  </head>

  <body class="pb-5 mb-4">
    <header class="bg-dark text-white mb-5 pt-4 pb-3 sticky-top">
      <div class="container">
        <div class="media">
          <i class="far fa-lightbulb fa-6x"></i>
          <div class="media-body pl-3">
            <h1>Vagrant (public folder) works!</h1>
            <p class="lead">The Virtual Machine is up and running! <i class="fas fa-smile-wink align-middle"></i></p>
          </div>
        </div>
      </div>
    </header>
    <main class="container">
      <h2>Installed software</h2>
      <table class="table table-striped">
        <tr>
          <td>Apache</td>
          <td>
            <?php 
              $apache_version = explode( '/', apache_get_version() );
              echo $apache_version[1];
            ?>
          </td>
        </tr>

        <tr>
          <td>PHP</td>
          <td>
            <?php
                $php_version = explode(".", phpversion());
                echo "$php_version[0].$php_version[1]";
            ?>
          </td>
        </tr>

        <tr>
          <td>MySQL</td>
          <td>
            <?php
              if (exec('mysql -V')) {
                  $my_version = explode(" ", exec('mysql -V'));
              }
              echo ($my_version ? $my_version[2] : 'N/A');
            ?>
          </td>
        </tr>

        <tr>
          <td>PostgreSQL</td>
          <td>
            <?php
              if (exec('psql -V')) {
                $pg_version = explode(" ", exec('psql -V'));
              }
              echo ($pg_version ? $pg_version[2] : 'N/A');
            ?>
          </td>
        </tr>

        <tr>
          <td>Memcached</td>
          <td>
            <?php echo ($memcached_version ? $memcached_version : 'N/A'); ?>
          </td>
        </tr>

        <tr>
          <td>Npm</td>
          <td>
            <?php echo (exec('npm -v') ? exec('npm -v') : 'N/A'); ?>
          </td>
        </tr>

        <tr>
          <td>Node.js</td>
          <td>
            <?php echo (exec('nodejs -v') ? ltrim(exec('nodejs -v'), 'v') : 'N/A'); ?>
          </td>
        </tr>

        <tr>
          <td>Yarn</td>
          <td>
            <?php echo (exec('yarn -v') ? exec('yarn -v') : 'N/A'); ?>
          </td>
        </tr>
      </table>

      <h2>PHP Modules</h2>
      <table class="table table-striped">
        <tr>
          <td>MySQL</td>
          <td><i class="fas fa-<?php echo (class_exists('mysqli') ? 'check' : 'times'); ?>"></i></td>
        </tr>

        <tr>
          <td>CURL</td>
          <td><i class="fas fa-<?php echo (function_exists('curl_init') ? 'check' : 'times'); ?>"></i></td>
        </tr>

        <tr>
          <td>mcrypt</td>
          <td><i class="fas fa-<?php echo (function_exists('mcrypt_encrypt') ? 'check' : 'times'); ?>"></i></td>
        </tr>

        <tr>
          <td>memcached</td>
          <td><i class="fas fa-<?php echo (class_exists('Memcached') ? 'check' : 'times'); ?>"></i></td>
        </tr>

        <tr>
          <td>gd</td>
          <td><i class="fas fa-<?php echo (function_exists('imagecreate') ? 'check' : 'times'); ?>"></i></td>
        </tr>
      </table>
    </main>
    <footer class="bg-dark text-white-50 pt-3 pb-1 mt-5 fixed-bottom">
      <div class="container">
        <p class="text-center">Vagrant stack by VeV-VA Vyškov</p>
      </div>
    </footer>
  </body>

  </html>
